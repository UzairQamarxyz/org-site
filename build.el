;; Load the publishing system
(require 'ox-publish)

(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

(setq org-src-fontify-natively t)

;; (setq org-html-htmlize-output-type 'inline-css) ;; default
(setq org-html-htmlize-output-type 'css)

;; (setq org-html-htmlize-font-prefix "") ;; default
(setq org-html-htmlize-font-prefix "org-")

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "my-org-site"
             :recursive t
             :base-directory "./content"
             :publishing-directory "./public"
             :publishing-function 'org-html-publish-to-html
             :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc t                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil)))    ;; Don't include time stamp in file

;; Customize the HTML output
(setq org-html-validation-link nil             ;; Don't show validation link
      org-html-head-include-scripts nil        ;; Use our own scripts
      org-html-head-include-default-style nil  ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"assets/rethink_inline.css\" />")

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
