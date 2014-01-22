
(fset 'yes-or-no-p 'y-or-n-p)

(defadvice x-set-selection (after replicate-selection (type data) activate)
  "Different applications use different data sources"
  (if (equal type 'CLIPBOARD)
      (x-set-selection 'PRIMARY data)))

(defadvice windmove-do-window-select (around silent-windmove activate)
  "Do not beep when no suitable window is found."
  (condition-case () ad-do-it (error nil)))

(eval-after-load "comint"
  '(defadvice comint-previous-input (around move-free (arg) activate)
     "No more 'Not at command line'"
     (if (comint-after-pmark-p)
         ad-do-it
       (backward-paragraph arg))))
