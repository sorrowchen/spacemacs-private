;;; packages.el --- zilongshanren Layer packages File for Spacemacs
;;
;; Copyright (c) 2014-2016 zilongshanren
;;
;; Author: zilongshanren <guanghui8827@gmail.com>
;; URL: https://github.com/zilongshanren/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq zilongshanren-misc-packages
      '(
        projectile
        prodigy
        find-file-in-project
        multiple-cursors
        visual-regexp
        visual-regexp-steroids
        command-log
        evil
        fcitx
        discover-my-major
        ace-window
        avy
        4clojure
        persp-mode
        helm-github-stars
        youdao-dictionary
        helm
        tiny
        smartparens
        flyspell-correct
        peep-dired
        markdown-mode
        swiper
        magit
        git-messenger
        company
        gist
        hydra
        ))

(defun zilongshanren-misc/post-init-hydra ()
  (progn
    (defhydra hydra-hotspots (:color blue)
      "Hotspots"
      ("b" org-octopress "blog")
      ("g" helm-github-stars "helm github stars")
      ("r" zilongshanren/run-current-file "run current file"))
    (define-key global-map (kbd "<f1>") 'hydra-hotspots/body)
    (spacemacs/set-leader-keys "oo" 'hydra-hotspots/body)

    ))

(defun zilongshanren-misc/post-init-gist ()
  (use-package gist
    :defer t
    :init
    (setq gist-list-format
      '((files "File" 30 nil "%s")
        (id "Id" 10 nil identity)
        (created "Created" 20 nil "%D %R")
        (visibility "Visibility" 10 nil
                    (lambda
                      (public)
                      (or
                       (and public "public")
                       "private")))
        (description "Description" 0 nil identity)))
    :config
    (progn
      (spacemacs|define-transient-state gist-list-mode
        :title "Gist-mode Transient State"
        :bindings
        ("k" gist-kill-current "delete gist")
        ("e" gist-edit-current-description "edit gist title")
        ("+" gist-add-buffer "add a file")
        ("-" gist-remove-file "delete a file")
        ("y" gist-print-current-url "print url")
        ("b" gist-browse-current-url "browse gist in browser")
        ("*" gist-star "star gist")
        ("^" gist-unstar "unstar gist")
        ("f" gist-fork "fork gist")
        ("q" nil "quit" :exit t)
        ("<escape>" nil nil :exit t))
      (spacemacs/set-leader-keys-for-major-mode 'gist-list-mode
        "." 'spacemacs/gist-list-mode-transient-state/body))
    ))

(defun zilongshanren-misc/init-peep-dired ()
  ;;preview files in dired
  (use-package peep-dired
    :defer t
    :commands (peep-dired-next-file
               peep-dired-prev-file)
    :bind (:map dired-mode-map
                ("P" . peep-dired))))


(defun zilongshanren-misc/post-init-flyspell-correct ()
  (progn
    (with-eval-after-load 'flyspell
      (define-key flyspell-mode-map (kbd "C-;") 'flyspell-correct-word-generic))
    (setq flyspell-correct-interface 'flyspell-correct-ivy)))

(defun zilongshanren-misc/post-init-smartparens ()
  (use-package smartparens
    :defer t
    :init
    (progn
      (defun wrap-sexp-with-new-round-parens ()
        (interactive)
        (insert "()")
        (backward-char)
        (sp-forward-slurp-sexp))

      (global-set-key (kbd "C-(") 'wrap-sexp-with-new-round-parens))
    :config
    (progn
      (setq sp-highlight-pair-overlay nil)

      (evil-define-key 'normal sp-keymap
        (kbd ")>") 'sp-forward-slurp-sexp
        (kbd ")<") 'sp-forward-barf-sexp
        (kbd "(>") 'sp-backward-barf-sexp
        (kbd "(<") 'sp-backward-slurp-sexp))))

(defun zilongshanren-misc/init-tiny ()
  (use-package tiny
    :defer t
    :init
    (spacemacs/set-leader-keys "oe" 'tiny-expand)))

(defun zilongshanren-misc/post-init-helm ()
  (with-eval-after-load 'helm
    (progn
      ;; limit max number of matches displayed for speed
      (setq helm-candidate-number-limit 100)
      ;; ignore boring files like .o and .a
      (setq helm-ff-skip-boring-files t)
      ;; replace locate with spotlight on Mac
      (setq helm-locate-command "mdfind -name %s %s")
      (push "\\.emlx$" helm-boring-file-regexp-list)
      )
    ))

(defun zilongshanren-misc/init-youdao-dictionary ()
  (use-package youdao-dictionary
    :defer t
    :init
    (spacemacs/set-leader-keys "oy" 'youdao-dictionary-search-at-point+)
    ))



(defun zilongshanren-misc/init-helm-github-stars ()
  (use-package helm-github-stars
    :commands (helm-github-stars)
    :init
    (setq helm-github-stars-username "zilongshanren")))




(defun zilongshanren-misc/post-init-fcitx ()
  (fcitx-aggressive-setup))

(defun zilongshanren-misc/post-init-command-log ()
  (with-eval-after-load 'command-log-mode
    (setq clm/log-command-exceptions* (append clm/log-command-exceptions*
                                              '(evil-next-visual-line
                                                evil-previous-visual-line)))))



(defun zilongshanren-misc/init-litable ()
  (use-package litable
    :init
    :defer t))

(defun zilongshanren-misc/init-osx-dictionary ()
  (use-package osx-dictionary
    :init
    (progn
      (evilified-state-evilify osx-dictionary-mode osx-dictionary-mode-map)
      (setq osx-dictionary-use-chinese-text-segmentation t)
      (global-set-key (kbd "C-c d") 'osx-dictionary-search-pointer)
      )))


(defun zilongshanren-misc/init-4clojure ()
  (use-package 4clojure
    :init
    (progn
      (spacemacs/declare-prefix "o4" "4clojure")
      (spacemacs/set-leader-keys "o4q" '4clojure-open-question)
      (spacemacs/set-leader-keys "o4n" '4clojure-next-question)
      (spacemacs/set-leader-keys "o4p" '4clojure-previous-question)
      (spacemacs/set-leader-keys "o4c" '4clojure-check-answers)
      )))




(defun zilongshanren-misc/post-init-avy ()
  (progn
    (global-set-key (kbd "C-s-'") 'avy-goto-char-2)
    (global-set-key (kbd "M-'") 'avy-goto-char-2)))

(defun zilongshanren-misc/post-init-ace-window ()
  (global-set-key (kbd "C-x C-o") #'ace-window))

(defun zilongshanren-misc/init-discover-my-major ()
  (use-package discover-my-major
    :defer t
    :init
    (progn
      (spacemacs/set-leader-keys (kbd "mhm") 'discover-my-major)

      (evilified-state-evilify makey-key-mode makey-key-mode-get-key-map))))





(defun zilongshanren-misc/post-init-elfeed ()
  (use-package elfeed
    :init
    (global-set-key (kbd "C-x w") 'elfeed)
    :defer t
    :config
    (progn

      (setq elfeed-feeds
            '("http://nullprogram.com/feed/"
              "http://z.caudate.me/rss/"
              "http://irreal.org/blog/?feed=rss2"
              "http://feeds.feedburner.com/LostInTheTriangles"
              "http://tonybai.com/feed/"
              "http://planet.emacsen.org/atom.xml"
              "http://feeds.feedburner.com/emacsblog"
              "http://blog.binchen.org/rss.xml"
              "http://oremacs.com/atom.xml"
              "http://blog.gemserk.com/feed/"
              "http://www.masteringemacs.org/feed/"
              "http://t-machine.org/index.php/feed/"
              "http://gameenginebook.blogspot.com/feeds/posts/default"
              "http://feeds.feedburner.com/ruanyifeng"
              "http://coolshell.cn/feed"
              "http://blog.devtang.com/atom.xml"
              "http://emacsist.com/rss"
              "http://puntoblogspot.blogspot.com/feeds/2507074905876002529/comments/default"
              "http://angelic-sedition.github.io/atom.xml"))

      ;; (evilify elfeed-search-mode elfeed-search-mode-map)
      (evilified-state-evilify-map elfeed-search-mode-map
        :mode elfeed-search-mode
        :bindings
        "G" 'elfeed-update
        "g" 'elfeed-search-update--force)

      (defun zilong/elfeed-mark-all-as-read ()
        (interactive)
        (mark-whole-buffer)
        (elfeed-search-untag-all-unread))

      (define-key elfeed-search-mode-map (kbd "R") 'zilong/elfeed-mark-all-as-read)

      (defadvice elfeed-show-yank (after elfeed-show-yank-to-kill-ring activate compile)
        "Insert the yanked text from x-selection to kill ring"
        (kill-new (x-get-selection)))

      (ad-activate 'elfeed-show-yank))))

(defun zilongshanren-misc/post-init-evil ()
  (progn
    (setcdr evil-insert-state-map nil)
    (define-key evil-insert-state-map [escape] 'evil-normal-state)

    (push "TAGS" spacemacs-useless-buffers-regexp)

    ;; ;; change evil initial mode state
    (loop for (mode . state) in
          '((shell-mode . normal))
          do (evil-set-initial-state mode state))

    ;;mimic "nzz" behaviou in vim
    (defadvice evil-ex-search-next (after advice-for-evil-search-next activate)
      (evil-scroll-line-to-center (line-number-at-pos)))

    (defadvice evil-ex-search-previous (after advice-for-evil-search-previous activate)
      (evil-scroll-line-to-center (line-number-at-pos)))

    (define-key evil-normal-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)

    (define-key evil-normal-state-map
      (kbd "Y") 'zilongshanren/yank-to-end-of-line)

    ;; rebind g,k to gj and gk
    ;; (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
    ;; (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

    (define-key evil-normal-state-map (kbd "[ SPC") (lambda () (interactive) (evil-insert-newline-above) (forward-line)))
    (define-key evil-normal-state-map (kbd "] SPC") (lambda () (interactive) (evil-insert-newline-below) (forward-line -1)))


    (define-key evil-normal-state-map (kbd "[ b") 'spacemacs/previous-useful-buffer)
    (define-key evil-normal-state-map (kbd "] b") 'spacemacs/next-useful-buffer)

    ;; (define-key evil-insert-state-map "\C-e" 'end-of-line)
    ;; (define-key evil-insert-state-map "\C-n" 'next-line)
    ;; (define-key evil-insert-state-map "\C-k" 'kill-line)
    (define-key evil-emacs-state-map (kbd "s-f") 'forward-word)
    (define-key evil-insert-state-map (kbd "s-f") 'forward-word)
    (define-key evil-emacs-state-map (kbd "s-b") 'backward-word)
    (define-key evil-insert-state-map (kbd "s-b") 'backward-word)

    (spacemacs/set-leader-keys "bi" 'ibuffer)
    (define-key evil-ex-completion-map "\C-a" 'move-beginning-of-line)
    (define-key evil-ex-completion-map "\C-b" 'backward-char)
    (define-key evil-ex-completion-map "\C-k" 'kill-line)
    (define-key minibuffer-local-map (kbd "C-w") 'evil-delete-backward-word)

    (define-key evil-visual-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
    ;; (define-key evil-visual-state-map (kbd "x") 'er/expand-region)
    ;; (define-key evil-visual-state-map (kbd "X") 'er/contract-region)
    (define-key evil-visual-state-map (kbd "C-r") 'zilongshanren/evil-quick-replace)

    ;; in spacemacs, we always use evilify miscro state
    (evil-add-hjkl-bindings package-menu-mode-map 'emacs)

    ;; (define-key evil-emacs-state-map (kbd "C-w h") 'evil-window-left)
    (define-key evil-emacs-state-map (kbd "C-w") 'evil-delete-backward-word)
    ;; (define-key evil-emacs-state-map (kbd "C-w j") 'evil-window-down)
    ;; (define-key evil-emacs-state-map (kbd "C-w k") 'evil-window-up)
    ;; (define-key evil-emacs-state-map (kbd "C-w l") 'evil-window-right)

    ;; for emacs shell mode
    ;; (define-key evil-emacs-state-map (kbd "s-b") 'ido-switch-buffer)
    ;; (define-key evil-emacs-state-map (kbd "s-f") 'ido-find-file)
    (evil-define-key 'emacs term-raw-map (kbd "C-w")
      'evil-delete-backward-word)


    (setq evil-normal-state-tag   (propertize "[N]" 'face '((:background "DarkGoldenrod2" :foreground "black")))
          evil-emacs-state-tag    (propertize "[E]" 'face '((:background "SkyBlue2" :foreground "black")))
          evil-insert-state-tag   (propertize "[I]" 'face '((:background "chartreuse3") :foreground "white"))
          evil-motion-state-tag   (propertize "[M]" 'face '((:background "plum3") :foreground "white"))
          evil-visual-state-tag   (propertize "[V]" 'face '((:background "gray" :foreground "black")))
          evil-operator-state-tag (propertize "[O]" 'face '((:background "purple"))))

    (define-key evil-insert-state-map (kbd "C-z") 'evil-emacs-state)
    ;; This will break visual column edit
    ;; enable hybrid editing style
    ;; (defadvice evil-insert-state (around zilongshanren/holy-mode activate)
    ;;   "Preparing the holy water flasks."
    ;;   (evil-emacs-state))
    ;; disable c-[ temporally
    ;; (define-key input-decode-map [?\C-\[] (kbd "<C-[>"))
    ;; (bind-keys ("<C-[>" . evil-normal-state))
    ;; (setq evil-emacs-state-cursor '("chartreuse3" (bar . 2)))
    ;; (define-key evil-emacs-state-map [escape] 'evil-normal-state)
    ))

;(defun zilongshanren-misc/init-hydra ()
;  (use-package hydra
;    :init
;    (progn
;      ;; major mode hydra is really cool, don't need to switch mode anymore
;      ;; C-c [a-z] and s-[a-z] is very quick to pressed even in emacs-state and F1-F9 is also the same
;      ;; If the command will change the buffer, they should be put in these groups.
;      ;; otherwise, use which-key + spacems + user defined key mappings in evil normal mode
;      (defhydra hydra-yasnippet (:color blue :hint nil)
;        "
;              ^YASnippets^
;--------------------------------------------
;  Modes:    Load/Visit:    Actions:
;
; _g_lobal  _d_irectory    _i_nsert
; _m_inor   _f_ile         _t_ryout
; _e_xtra   _l_ist         _n_ew
;         _a_ll
;"
;        ("d" yas-load-directory)
;        ("e" yas-activate-extra-mode)
;        ("i" yas-insert-snippet)
;        ("f" yas-visit-snippet-file :color blue)
;        ("n" yas-new-snippet)
;        ("t" yas-tryout-snippet)
;        ("l" yas-describe-tables)
;        ("g" yas/global-mode)
;        ("m" yas/minor-mode)
;        ("a" yas-reload-all))
;
;
;      (defhydra hydra-apropos (:color blue)
;        "Apropos"
;        ("a" apropos "apropos")
;        ("c" apropos-command "cmd")
;        ("d" apropos-documentation "doc")
;        ("e" apropos-value "val")
;        ("l" apropos-library "lib")
;        ("o" apropos-user-option "option")
;        ("u" apropos-user-option "option")
;        ("v" apropos-variable "var")
;        ("i" info-apropos "info")
;        ("t" tags-apropos "tags")
;        ("z" hydra-customize-apropos/body "customize"))
;
;      (defhydra hydra-customize-apropos (:color blue)
;        "Apropos (customize)"
;        ("a" customize-apropos "apropos")
;        ("f" customize-apropos-faces "faces")
;        ("g" customize-apropos-groups "groups")
;        ("o" customize-apropos-options "options"))
;
;      (bind-key*  "<f4>" 'hydra-apropos/body)
;      )))

(defun zilongshanren-misc/post-init-company-c-headers ()
  (progn
    (setq company-c-headers-path-system
          (quote
           ("/usr/include/" "/usr/local/include/" "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1")))
    (setq company-c-headers-path-user
          (quote
           ("/Users/guanghui/cocos2d-x/cocos/platform" "/Users/guanghui/cocos2d-x/cocos" "." "/Users/guanghui/cocos2d-x/cocos/audio/include/")))))



(defun zilongshanren-misc/init-visual-regexp ()
  (use-package visual-regexp
    :commands (vr/replace vr/query-replace)))

(defun zilongshanren-misc/init-visual-regexp-steroids ()
  (use-package visual-regexp-steroids
    :commands (vr/select-replace vr/select-query-replace)
    :init
    (progn
      (define-key global-map (kbd "C-c r") 'vr/replace)
      (define-key global-map (kbd "C-c q") 'vr/query-replace))))

(defun zilongshanren-misc/init-multiple-cursors ()
  (use-package multiple-cursors
    :init
    (progn

      (bind-key* "C-s-l" 'mc/edit-lines)
      (bind-key* "C-s-f" 'mc/mark-all-dwim)
      (bind-key* "C-s-." 'mc/mark-next-like-this)
      (bind-key* "C-s-," 'mc/mark-previous-like-this)
      (bind-key* "s->" 'mc/unmark-next-like-this)
      (bind-key* "s-<" 'mc/unmark-previous-like-this)
      (bind-key* "C-c C-s-." 'mc/mark-all-like-this)

      ;; http://endlessparentheses.com/multiple-cursors-keybinds.html?source=rss
      (define-prefix-command 'endless/mc-map)
      ;; C-x m is usually `compose-mail'. Bind it to something
      ;; else if you use this command.
      (define-key ctl-x-map "m" 'endless/mc-map)
;;; Really really nice!
      (define-key endless/mc-map "i" #'mc/insert-numbers)
      (define-key endless/mc-map "h" #'mc-hide-unmatched-lines-mode)
      (define-key endless/mc-map "a" #'mc/mark-all-like-this)

;;; Occasionally useful
      (define-key endless/mc-map "d" #'mc/mark-all-symbols-like-this-in-defun)
      (define-key endless/mc-map "r" #'mc/reverse-regions)
      (define-key endless/mc-map "s" #'mc/sort-regions)
      (define-key endless/mc-map "l" #'mc/edit-lines)
      (define-key endless/mc-map "\C-a" #'mc/edit-beginnings-of-lines)
      (define-key endless/mc-map "\C-e" #'mc/edit-ends-of-lines)
      )
    :config
    (setq mc/cmds-to-run-for-all
          '(
            electric-newline-and-maybe-indent
            hungry-delete-backward
            spacemacs/backward-kill-word-or-region
            spacemacs/smart-move-beginning-of-line
            lispy-move-beginning-of-line
            lispy-move-end-of-line
            lispy-space
            lispy-delete-backward
            evil-exit-visual-state
            evil-backward-char
            evil-delete-char
            evil-escape-emacs-state
            evil-escape-insert-state
            evil-exit-emacs-state
            evil-previous-visual-line
            evil-next-visual-line
            evil-forward-char
            evil-insert
            evil-next-line
            evil-normal-state
            evil-previous-line
            evil-append
            evil-append-line
            forward-sentence
            kill-sentence
            org-self-insert-command
            sp-backward-delete-char
            sp-delete-char
            sp-remove-active-pair-overlay))))

(defun zilongshanren-misc/post-init-persp-mode ()
  (when (fboundp 'spacemacs|define-custom-layout)
    (spacemacs|define-custom-layout "@Cocos2D-X"
      :binding "c"
      :body
      (find-file "~/cocos2d-x/cocos/ui/UIWidget.cpp")
      (split-window-right)
      (find-file "~/cocos2d-x/cocos/cocos2d.cpp"))))

(defun zilongshanren-misc/post-init-chinese-wbim ()
  (progn
    ;; [[http://emacs.stackexchange.com/questions/352/how-to-override-major-mode-bindings][keymap - How to override major mode bindings - Emacs Stack Exchange]]
    (bind-key* ";" 'chinese-wbim-insert-ascii)
    (setq chinese-wbim-punc-translate-p nil)
    (spacemacs/declare-prefix "ot" "Toggle")
    (spacemacs/set-leader-keys
      "otp" 'chinese-wbim-punc-translate-toggle)
    (setq chinese-wbim-wb-use-gbk t)
    (add-hook 'chinese-wbim-wb-load-hook
              (lambda ()
                (let ((map (chinese-wbim-mode-map)))
                  (define-key map "-" 'chinese-wbim-previous-page)
                  (define-key map "=" 'chinese-wbim-next-page))))
    ))

(defun zilongshanren-misc/post-init-youdao-dictionary ()
  (spacemacs/set-leader-keys "oy" 'youdao-dictionary-search-at-point+))


(defun zilongshanren-misc/post-init-evil-escape ()
  (setq evil-escape-delay 0.2))

(defun zilongshanren-misc/init-find-file-in-project ()
  (use-package find-file-in-project
    :defer t
    :config
    (progn
      (defun zilongshanren/search-in-fireball ()
        (interactive)
        (counsel-ag "" (expand-file-name "~/Github/fireball/")))
      (spacemacs/set-leader-keys "os" 'zilongshanren/search-in-fireball)

      ;; If you use other VCS (subversion, for example), enable the following option
      ;;(setq ffip-project-file ".svn")
      ;; in MacOS X, the search file command is CMD+p
      (bind-key* "s-p" 'find-file-in-project)
      ;; for this project, I'm only interested certain types of files
      ;; (setq-default ffip-patterns '("*.html" "*.js" "*.css" "*.java" "*.xml" "*.js"))
      ;; if the full path of current file is under SUBPROJECT1 or SUBPROJECT2
      ;; OR if I'm reading my personal issue track document,
      (defadvice find-file-in-project (before my-find-file-in-project activate compile)
        (when (ffip-current-full-filename-match-pattern-p "\\(/fireball\\)")
          ;; set the root directory into "~/projs/PROJECT_DIR"
          (setq-local ffip-project-root "~/Github/fireball")
          ;; well, I'm not interested in concatenated BIG js file or file in dist/
          (setq-local ffip-find-options "-not -size +64k -not -iwholename '*/bin/*'")
          ;; do NOT search files in below directories, the default value is better.
          (dolist (item '("*/docs/html/*" "*.meta" "*/cocos2d-x/*" "*.asset" "*/visual-tests/res/*"))
            (push item  ffip-prune-patterns)))
        (when (ffip-current-full-filename-match-pattern-p "\\(/cocos2d-x\\)")
          ;; set the root directory into "~/projs/PROJECT_DIR"
          (setq-local ffip-project-root "~/cocos2d-x")
          ;; well, I'm not interested in concatenated BIG js file or file in dist/
          (setq-local ffip-find-options "-not -size +64k -not -iwholename '*/bin/*'")
          ;; do NOT search files in below directories, the default value is better.
          ;; (setq-default ffip-prune-patterns '(".git" ".hg" "*.svn" "node_modules" "bower_components" "obj"))
          ))
      (ad-activate 'find-file-in-project))))




(defun zilongshanren-misc/post-init-projectile ()
  (progn
    (with-eval-after-load 'projectile
      (progn
        (setq projectile-completion-system 'ivy)
        (add-to-list 'projectile-other-file-alist '("html" "js"))
        (add-to-list 'projectile-other-file-alist '("js" "html"))))

    (defvar my-simple-todo-regex "\\<\\(FIXME\\|TODO\\|BUG\\):")

    (defun my-simple-todo ()
      "When in a project, create a `multi-occur' buffer matching the
  regex in `my-simple-todo-regex' across all buffers in the
  current project. Otherwise do `occur' in the current file."
      (interactive)
      (if (projectile-project-p)
          (multi-occur (projectile-project-buffers) my-simple-todo-regex)
        (occur my-simple-todo-regex)))
    (spacemacs/set-leader-keys "pf" 'zilongshanren/open-file-with-projectile-or-counsel-git)
    (spacemacs/set-leader-keys "pt" 'my-simple-todo)))



(defun zilongshanren-misc/post-init-prodigy ()
  (progn
    (prodigy-define-tag
      :name 'jekyll
      :env '(("LANG" "en_US.UTF-8")
             ("LC_ALL" "en_US.UTF-8")))
    ;; define service
    (prodigy-define-service
      :name "Preview cocos2d-x web"
      :command "python"
      :args '("-m" "SimpleHTTPServer" "6001")
      :cwd "~/cocos2d-x/web"
      :tags '(work)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Preview creator engine"
      :command "python"
      :args '("-m" "SimpleHTTPServer" "6004")
      :cwd "~/Github/fireball/engine"
      :tags '(work)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Hexo Server"
      :command "hexo"
      :args '("server")
      :cwd "~/4gamers.cn"
      :tags '(hexo server)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Hexo Deploy"
      :command "hexo"
      :args '("deploy" "--generate")
      :cwd "~/4gamers.cn"
      :tags '(hexo deploy)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Debug Fireball"
      :command "npm"
      :args '("start" "--" "--nologin" "/Users/guanghui/Github/example-cases")
      :cwd "~/Github/fireball/"
      :tags '(work)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Org wiki preview"
      :command "python"
      :args '("-m" "SimpleHTTPServer" "8088")
      :cwd "~/org-notes/public_html"
      :tags '(org-mode)
      :init (lambda () (browse-url "http://localhost:8088"))
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)))

(defun zilongshanren-misc/init-moz-controller ()
  (use-package moz-controller
    :init
    (moz-controller-global-mode t)
    :diminish moz-controller-mode))


(defun zilongshanren-misc/init-ag ()
  (use-package ag
    :init))

(defun zilongshanren-misc/post-init-erc ()
  (progn
    (defun my-erc-hook (match-type nick message)
      "Shows a growl notification, when user's nick was mentioned. If the buffer is currently not visible, makes it sticky."
      (unless (posix-string-match "^\\** *Users on #" message)
        (zilongshanren/growl-notification
         (concat "ERC: : " (buffer-name (current-buffer)))
         message
         t
         )))

    (add-hook 'erc-text-matched-hook 'my-erc-hook)
    (spaceline-toggle-erc-track-off)))

(defun zilongshanren-misc/init-wrap-region ()
  (use-package wrap-region
    :init
    (progn
      (wrap-region-global-mode t)
      (wrap-region-add-wrappers
       '(("$" "$")
         ("{-" "-}" "#")
         ("/" "/" nil ruby-mode)
         ("/* " " */" "#" (java-mode javascript-mode css-mode js2-mode))
         ("`" "`" nil (markdown-mode ruby-mode))))
      (add-to-list 'wrap-region-except-modes 'dired-mode)
      (add-to-list 'wrap-region-except-modes 'web-mode)
      )
    :defer t
    :config
    (spacemacs|hide-lighter wrap-region-mode)))

(defun zilongshanren-misc/post-init-company ()
  (progn
    (setq company-minimum-prefix-length 1
          company-idle-delay 0.08)

    (when (configuration-layer/package-usedp 'company)
      (spacemacs|add-company-hook shell-script-mode)
      (spacemacs|add-company-hook makefile-bsdmake-mode)
      (spacemacs|add-company-hook sh-mode)
      (spacemacs|add-company-hook lua-mode)
      (spacemacs|add-company-hook nxml-mode)
      (spacemacs|add-company-hook conf-unix-mode)
      )
    ))


(defun zilongshanren-misc/init-keyfreq ()
  (use-package keyfreq
    :init
    (progn
      (keyfreq-mode t)
      (keyfreq-autosave-mode 1))))

(defun zilongshanren-misc/post-init-swiper ()
  "Initialize my package"
  (progn
    (defun my-swiper-search (p)
      (interactive "P")
      (let ((current-prefix-arg nil))
        (call-interactively
         (if p #'spacemacs/swiper-region-or-symbol
           #'swiper))))

    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (use-package recentf
      :config
      (setq recentf-exclude
            '("COMMIT_MSG" "COMMIT_EDITMSG" "github.*txt$"
              ".*png$"))
      (setq recentf-max-saved-items 60))
    (evilified-state-evilify ivy-occur-mode ivy-occur-mode-map)

    (use-package ivy
      :defer t
      :config
      (progn
        (spacemacs|hide-lighter ivy-mode)

        (defun ivy-insert-action (x)
          (with-ivy-window
            (insert x)))

        (defun ivy-ff-checksum ()
          (interactive)
          "Calculate the checksum of FILE. The checksum is copied to kill-ring."
          (let ((file (expand-file-name ivy--current ivy--directory))
                (algo (intern (ivy-read
                               "Algorithm: "
                               '(md5 sha1 sha224 sha256 sha384 sha512)))))
            (kill-new (with-temp-buffer
                        (insert-file-contents-literally file)
                        (secure-hash algo (current-buffer))))
            (message "Checksum copied to kill-ring.")))

        (ivy-set-actions
         t
         '(("I" ivy-insert-action "insert")))

        ;; http://blog.binchen.org/posts/use-ivy-to-open-recent-directories.html
        (defun counsel-goto-recent-directory ()
          "Recent directories"
          (interactive)
          (unless recentf-mode (recentf-mode 1))
          (let ((collection
                 (delete-dups
                  (append (mapcar 'file-name-directory recentf-list)
                          ;; fasd history
                          (if (executable-find "fasd")
                              (split-string (shell-command-to-string "fasd -ld") "\n" t))))))
            (ivy-read "directories:" collection
                      :action 'dired
                      :caller 'counsel-goto-recent-directory)))
        (spacemacs/set-leader-keys "fad" 'counsel-goto-recent-directory)

        (setq ivy-initial-inputs-alist nil)

        (when (not (configuration-layer/layer-usedp 'helm))
          (spacemacs/set-leader-keys "sp" 'counsel-git-grep)
          (spacemacs/set-leader-keys "sP" 'spacemacs/counsel-git-grep-region-or-symbol))
        (define-key ivy-minibuffer-map (kbd "C-c o") 'ivy-occur)
        (define-key ivy-minibuffer-map (kbd "TAB") 'ivy-call)
        (define-key ivy-minibuffer-map (kbd "C-s-m") 'ivy-partial-or-done)
        (define-key ivy-minibuffer-map (kbd "C-c s") 'ivy-ff-checksum)
        (define-key ivy-minibuffer-map (kbd "s-o") 'ivy-dispatching-done)
        (define-key ivy-minibuffer-map (kbd "C-c C-e") 'counsel-git-grep-query-replace)
        (define-key ivy-minibuffer-map (kbd "<f3>") 'ivy-occur)
        (define-key ivy-minibuffer-map (kbd "C-s-j") 'ivy-immediate-done)
        (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
        (define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)))

    (define-key global-map (kbd "C-s") 'my-swiper-search)
    ))


(defun zilongshanren-misc/post-init-magit ()
  (progn
    (with-eval-after-load 'magit
      (progn
        (add-to-list 'magit-no-confirm 'stage-all-changes)
        (define-key magit-log-mode-map (kbd "W") 'magit-copy-section-value)
        (define-key magit-status-mode-map (kbd "s-1") 'magit-jump-to-unstaged)
        (define-key magit-status-mode-map (kbd "s-2") 'magit-jump-to-untracked)
        (define-key magit-status-mode-map (kbd "s-3") 'magit-jump-to-staged)
        (define-key magit-status-mode-map (kbd "s-4") 'magit-jump-to-stashes)
        (setq magit-completing-read-function 'magit-builtin-completing-read)

        ;; http://emacs.stackexchange.com/questions/6021/change-a-branchs-upstream-with-magit/6023#6023
        (magit-define-popup-switch 'magit-push-popup ?u
          "Set upstream" "--set-upstream")
        ;; (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)
        ;; (add-hook 'magit-section-set-visibility-hook '(lambda (section) (let ((section-type (magit-section-type section)))
        ;;                                                              (if (or (eq 'untracked section-type)
        ;;                                                                      (eq 'stashes section-type))
        ;;                                                                  'hide))))
        ))

    ;; Githu PR settings
    ;; "http://endlessparentheses.com/create-github-prs-from-emacs-with-magit.html"
    (setq magit-repository-directories '("~/cocos2d-x/"))
    (setq magit-push-always-verify nil)


    (defun zilongshanren/magit-visit-pull-request ()
      "Visit the current branch's PR on GitHub."
      (interactive)
      (let ((remote-branch (magit-get-current-branch)))
        (cond
         ((null remote-branch)
          (message "No remote branch"))
         (t
          (browse-url
           (format "https://github.com/%s/pull/new/%s"
                   (replace-regexp-in-string
                    "\\`.+github\\.com:\\(.+\\)\\.git\\'" "\\1"
                    (magit-get "remote"
                               (magit-get-remote)
                               "url"))
                   remote-branch))))))

    (eval-after-load 'magit
      '(define-key magit-mode-map (kbd "C-c g")
         #'zilongshanren/magit-visit-pull-request))

    (setq magit-process-popup-time 10)))

(defun zilongshanren-misc/post-init-git-messenger ()
  (use-package git-messenger
    :defer t
    :config
    (progn
      (defun zilong/github-browse-commit ()
        "Show the GitHub page for the current commit."
        (interactive)
        (use-package github-browse-file
          :commands (github-browse-file--relative-url))

        (let* ((commit git-messenger:last-commit-id)
               (url (concat "https://github.com/"
                            (github-browse-file--relative-url)
                            "/commit/"
                            commit)))
          (github-browse--save-and-view url)
          (git-messenger:popup-close)))

      (define-key git-messenger-map (kbd "f") 'zilong/github-browse-commit))))

(defun zilongshanren-misc/post-init-markdown-mode ()
  (progn
    (add-to-list 'auto-mode-alist '("\\.mdown\\'" . markdown-mode))

    (with-eval-after-load 'markdown-mode
      (progn
        ;; (when (configuration-layer/package-usedp 'company)
        ;;   (spacemacs|add-company-hook markdown-mode))

        (defun zilongshanren/markdown-to-html ()
          (interactive)
          (start-process "grip" "*gfm-to-html*" "grip" (buffer-file-name) "5000")
          (browse-url (format "http://localhost:5000/%s.%s" (file-name-base) (file-name-extension (buffer-file-name)))))

        (spacemacs/set-leader-keys-for-major-mode 'gfm-mode-map
          "p" 'zilongshanren/markdown-to-html)
        (spacemacs/set-leader-keys-for-major-mode 'markdown-mode
          "p" 'zilongshanren/markdown-to-html)

        (evil-define-key 'normal markdown-mode-map (kbd "TAB") 'markdown-cycle)
        ))
    ))
