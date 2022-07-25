(setq momo-trigger-vs "~/.emacs.d/taotao-plugin-settings/evs/evs-emacs/trigger-vs.el")
(setq momo-trigger-vs-template "~/.emacs.d/taotao-plugin-settings/evs/evs-emacs/trigger-vs.el.template")
;; 强制覆盖
(copy-file momo-trigger-vs-template momo-trigger-vs t)

(provide 'trigger-vs-origin)
