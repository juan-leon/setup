(use-package calendar
  :bind ([(control f4)] . calendar)
  :init
  (setq calendar-week-start-day     1
        calendar-mark-holidays-flag t
        calendar-holidays (append
                           ;; Fixed
                           '((holiday-fixed 1 1 "New Year's Day")
                             (holiday-fixed 1 6 "Reyes")
                             (holiday-easter-etc -2 "Jueves Santo")
                             (holiday-easter-etc -3 "Viernes Santo")
                             (holiday-fixed 5 1   "Dia del Trabajador")
                             (holiday-fixed 5 2   "Comunidad del Madrid")
                             (holiday-fixed 10 12 "National Day")
                             (holiday-fixed 12 6  "Constitution")
                             (holiday-fixed 12 25 "Christmas"))
                           ;; This year
                           '((holiday-fixed 3 20  "S. Jose")
                             (holiday-fixed 5 15  "Whatever")
                             (holiday-fixed 8 15  "Asuncion")
                             (holiday-fixed 11 1  "All Saints")
                             (holiday-fixed 11 9  "Almudena")
                             (holiday-fixed 12 8  "Concepcion")))))


(use-package time
  :defer t
  :config
  (setq display-time-world-list '(("America/Argentina/Buenos_Aires" "Buenos Aires")
                                  ("UTC" "UTC")
                                  ("Europe/Madrid" "Madrid"))))
