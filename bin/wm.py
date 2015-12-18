#!/usr/bin/env python3
from sh import wmctrl
from collections import namedtuple
import argparse
import pickle
import socket
import time
import os

# This utility is for working around Ubuntu Precise Unity bugs with multiple
# monitors, multiple desktops, and dell monitors using display port.


HOSTNAME = socket.gethostname()
FILENAME = os.path.join(os.getenv('HOME'), '.wmlist.data')


class Monitor(object):

    @staticmethod
    def number():
        return 1 + Geometry.work_area.width // 2000


class Geometry(object):

    full_area = None
    work_area = None
    desktop = None

    @classmethod
    def load(cls):
        line = wmctrl(d=True).strip().split()
        cls.full_area = cls.calculate_fa(*line[3].split('x'))
        cls.work_area = cls.calculate_wa(*(line[7].split(',') + line[8].split('x')))
        cls.desktop = cls.calculate_desktop(cls.work_area, *line[5].split(','))

    @staticmethod
    def calculate_fa(x, y):
        return Dim(int(x), int(y))

    @staticmethod
    def calculate_wa(x, y, width, height):
        return Dim(int(x) + int(width), int(y) + int(height))

    @staticmethod
    def calculate_desktop(wa, x, y):
        return Desktop(int(x) // wa.width, int(y) // wa.height)

    @classmethod
    def goto_desktop(cls, desktop=None):
        if desktop is None:
            desktop = cls.desktop
        x = desktop.x * cls.work_area.width
        y = desktop.y * cls.work_area.height
        wmctrl('-o', '%s,%s' % (x, y))

    @classmethod
    def get_desktop(cls, point):
        x = point.x + (cls.desktop.x * cls.work_area.width)
        y = point.y + (cls.desktop.y * cls.work_area.height)
        return Desktop(x // cls.work_area.width, y // cls.work_area.height)


class Point(namedtuple('Point', 'x y')):
    pass


class Dim(namedtuple('Dim', 'width height')):

    @property
    def area(self):
        return self.width * self.height

    def is_small(self):
        return self.area * 1.95 * Monitor.number() < Geometry.work_area.area


class Desktop(namedtuple('Desktop', 'x y')):

    def is_invisible(self):
        return self.x < 0 or self.y < 0


class WindowParser(object):

    ID, DESKTOP, PID, X, Y, WIDTH, HEIGHT, MACHINE, NAME = tuple(range(9))

    @classmethod
    def parse(cls, line):
        fields = line.strip().split(None, 8)
        return (
            fields[cls.ID],
            Point(int(fields[cls.X]), int(fields[cls.Y])),
            Dim(int(fields[cls.WIDTH]), int(fields[cls.HEIGHT])),
            fields[cls.MACHINE],
            fields[cls.NAME]
        )


class Window(object):

    max_properties = ['maximized_vert', 'maximized_horz']

    def __init__(self, line=None):
        self.id = None
        self.location = None
        self.dim = None
        self.machine = None
        self.name = None
        self.desktop = None
        if line:
            self.read(line)

    def read(self, line):
        self.id, self.location, self.dim, self.machine, self.name = WindowParser.parse(line)
        self.desktop = Geometry.get_desktop(self.location)

    def __str__(self):
        return '<Window %s: "%s">' % (self.id, self.name)

    def maximize(self):
        self.wmctrl('-b', ['add'] + self.max_properties)

    def unmaximize(self):
        self.wmctrl('-b', ['remove'] + self.max_properties)

    def wmctrl(self, option, args):
        print('-i', '-r', self.id, option, ','.join(args))
        wmctrl('-i', '-r', self.id, option, ','.join(args))

    def back_to_desktop(self):
        Geometry.goto_desktop(Desktop(0, 0))
        x = str(200 + (Geometry.work_area.width // 2) + (self.desktop.x * Geometry.work_area.width))
        y = str(self.desktop.y * Geometry.work_area.height)
        # This is the hack to workaoud the bug
        self.wmctrl('-e', ['0', x, y, '-1', '-1'])
        time.sleep(0.4)
        self.unmaximize()
        time.sleep(0.4)
        self.wmctrl('-e', ['0', x, y, '1800', '900'])
        time.sleep(0.4)
        self.maximize()
        time.sleep(0.4)
        self.wmctrl('-e', ['0', x, y, '-1', '-1'])

    def is_relevant(self):
        if self.dim.is_small():
            return False
        elif self.machine != HOSTNAME:
            return False
        if self.desktop.is_invisible():
            return False
        if self.name == 'Desktop':  # hack for ubuntu 15.10
            return False
        return True


class WindowList(object):

    def __init__(self):
        self.windows = None

    def save(self, filename):
        with open(filename, 'wb') as f:
            pickle.dump(self.windows, f)

    def load(self, filename=None):
        if filename is None:
            self.windows = [Window(x) for x in wmctrl(p=True, G=True, l=True)]
        else:
            with open(filename, 'rb') as f:
                self.windows = pickle.load(f)

    def filter(self):
        self.windows = list(filter(Window.is_relevant, self.windows))

    def __getitem__(self, index):
        return self.windows[index]


def save(args):
    windows = WindowList()
    windows.load()
    windows.filter()
    if args.verbose:
        for window in windows:
            print('Saved %s for %s' % (window, window.desktop))
        print('Saving data in %s' % FILENAME)
    windows.save(FILENAME)


def load(args):
    windows = WindowList()
    windows.load(FILENAME)
    for window in windows:
        if args.verbose:
            print('Loaded %s for %s' % (window, window.desktop))
        window.back_to_desktop()
    Geometry.goto_desktop()


def move(args):
    window = Window()
    window.id = args.id
    window.name = 'User specified window'
    window.desktop = Desktop(args.x, args.y)
    window.back_to_desktop()
    Geometry.goto_desktop()


def parse_args():
    parser = argparse.ArgumentParser(
        description='Helps to manage windows in broken unity/compiz'
    )
    parser.add_argument(
        '-v', '--verbose', action='store_true', help='show more output')
    subparsers = parser.add_subparsers(
        help='Type sub-command --help for help on sub-commands'
    )
    parser_save = subparsers.add_parser(
        'save', help='save current workspace to file'
    )
    parser_save.set_defaults(function=save)
    parser_load = subparsers.add_parser(
        'load', help='apply saved workspace to current windows'
    )
    parser_load.set_defaults(function=load)
    parser_move = subparsers.add_parser(
        'move', help='Move window to desktop'
    )
    parser_move.add_argument('id', help='Window ID')
    parser_move.add_argument('x', type=int, help='Numbering starts from 0')
    parser_move.add_argument('y', type=int, help='Numbering starts from 0')
    parser_move.set_defaults(function=move)
    args = parser.parse_args()
    args.function(args)


Geometry.load()
print(Monitor.number())
parse_args()

# virtualenv -p /usr/bin/python3 py3env
# source ~/py3env/bin/activate
