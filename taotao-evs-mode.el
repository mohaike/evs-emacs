(setq ns-pop-up-frames nil)

(defun momo-evs (arg-file-path char-number &optional opt1)
  "供外界打开Emacs到指定文件指定位置，传进来的第二个参数小于零，是文件"
  (interactive)
  (find-file arg-file-path)
  (if (< char-number 0)
      nil
    (progn
      ;; 第一次启动不高亮的Bug
      ;; 需要安装cliclick：https://github.com/BlueM/cliclick
      (if opt1
          (shell-command "cliclick kp:arrow-left;cliclick kp:arrow-right"))

      (goto-char char-number)
      (global-hl-line-highlight)        ;突然跳转会失去焦点
      (recenter-top-bottom '(middle)))))


(add-to-list 'load-path "~/.emacs.d/taotao-plugin-settings/evs/evs-emacs")
(add-to-list 'load-path "~/.emacs.d/taotao-plugin-settings/evs/evs-vscode")

(require 'evs-emacs-go)
(require 'evs-vscode-go)

(provide 'taotao-evs-mode)
