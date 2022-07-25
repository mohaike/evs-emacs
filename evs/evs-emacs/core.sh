#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
EL_GO="${CURRENT_PATH}/trigger-vs.el"


socket_file="$(lsof -c Emacs | grep server | tr -s " " | cut -d' ' -f8)"
emacs="/Applications/5.app"
emacsclient="/Applications/5.app/Contents/MacOS/bin/emacsclient"

fLine="${1}"
fColumn="${2}"
fPath="${3}"

go_init()
{
    ((fColumn--))                   # emacs里面的会小1
    # 先写入初始化启动文件
cat << MOMO > "${EL_GO}"
;; 打开文件，并且跳转到想要的位置
(find-file "${fPath}")
(goto-line ${fLine})
(move-to-column ${fColumn})
(provide 'trigger-vs)
MOMO

    # 启动emacs
    open -a "${emacs}"
}

go_client()
{
    $emacsclient -n +${fLine}:${fColumn} "${fPath}" --socket-name $socket_file
    # 切到英文
    $emacsclient -e "(sis-set-english)"
}

# 当前是否有emacs的服务
if [[ $socket_file == "" ]]; then
    # 执行elisp代码逻辑
    go_init
else
    # 执行shell代码逻辑（走的是client）
    go_client
fi
