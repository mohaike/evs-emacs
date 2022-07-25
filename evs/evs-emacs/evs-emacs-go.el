;; 开启server
(server-start)

;; 执行触发文件
(require 'trigger-vs)
;; 执行过后恢复
(require 'trigger-vs-origin)

;; 默认为英文
(sis-set-english)

(provide 'evs-emacs-go)
