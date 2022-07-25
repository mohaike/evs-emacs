(require 'f)
;; 创建目录
;; (f-mkdir "~" ".emacs.d" "tmp" "vscode")
(setq vscode_need_file "~/.emacs.d/taotao-plugin-settings/evs/evs-vscode/__tmp/vscode_get_value")

(setq vscode-value-file "~/.emacs.d/taotao-plugin-settings/evs/evs-vscode/__tmp/emacs-call-me-value.sh")

(defun init-shell-value ()
  (f-mkdir "~" ".emacs.d" "taotao-plugin-settings" "evs" "evs-vscode" "__tmp")
  (f-write-text "" 'utf-8 vscode_need_file)
  (f-write-text "" 'utf-8 vscode-value-file))

(init-shell-value)

;; 保存文件
(defun momo-save-current-buffer ()
  "是文件才保存"
  (if buffer-file-name
      (save-buffer)))

;; 写文件
(defun get-current-path (&optional φdir-path-only-p)
  (let ((fPath
         (if (equal major-mode 'dired-mode)
             default-directory
           (buffer-file-name))))
    (if (equal φdir-path-only-p nil)
        fPath
      (file-name-directory fPath))
    (f-append-text (concat "momo_file_path_o=\"" fPath "\"") 'utf-8 vscode-value-file)))

(defun call-vscode-send-value ()
  (init-shell-value)
  (f-write-text (concat "momo_line_o=\"" (what-line) "\"" "\n") 'utf-8 vscode-value-file)
  (f-append-text (concat "momo_char_position_o=\"" (what-cursor-position) "\"" "\n") 'utf-8 vscode-value-file)
  (f-append-text (concat "momo_column_o=\"" (what-cursor-position) "\"" "\n") 'utf-8 vscode-value-file)
  (get-current-path))

(defun emacs-call-vscode ()
  (shell-command "sh ~/.emacs.d/taotao-plugin-settings/evs/evs-vscode/emacs-call-me.sh"))

(defun evs-call-vscode ()
  (interactive "^")
  (momo-save-current-buffer)
  (call-vscode-send-value)
  (emacs-call-vscode))

;; Emacs唤起VScode
(global-set-key (kbd "<f10>") 'evs-call-vscode)
(global-set-key (kbd "S-<f10>") 'evs-call-vscode)

(provide 'evs-vscode-go)
