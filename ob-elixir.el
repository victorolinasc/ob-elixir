;;; ob-elixir.el --- org-babel functions for elixir evaluation

;; Copyright (C) 2015 Victor Olinasc

;; URL: https://github.com/victorolinasc/ob-elixir
;; Author: Victor Olinasc
;; Keywords: literate programming, reproducible research
;; Package-Requires: ((emacs "24"))
;; Homepage: http://orgmode.org

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; Org-mode language support for elixir. Currently this only supports
;; the external compilation and execution of elixir code blocks (i.e.,
;; no session support). This code is inspired by ob-java.el in org-mode
;; sources.

;;; Code:
(require 'ob)

(defvar org-babel-tangle-lang-exts)
(add-to-list 'org-babel-tangle-lang-exts '("elixir" . "exs"))

(defun org-babel-execute:elixir (body params)
  (let* ((src-file "orgmode_elixir_src.exs")
	 (full-body (org-babel-expand-body:generic body params))
	 (results
	  (progn (with-temp-file src-file (insert full-body))
		 (org-babel-eval
		  (concat "elixir" " " src-file) ""))))
    
    (org-babel-reassemble-table
       (org-babel-result-cond (cdr (assoc :result-params params))
	 (org-babel-read results)
         (let ((tmp-file (org-babel-temp-file "c-")))
           (with-temp-file tmp-file (insert results))
           (org-babel-import-elisp-from-file tmp-file)))
       (org-babel-pick-name
        (cdr (assoc :colname-names params)) (cdr (assoc :colnames params)))
       (org-babel-pick-name
        (cdr (assoc :rowname-names params)) (cdr (assoc :rownames params))))))

(provide 'ob-elixir)

;;; ob-elixir.el ends here
