#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
EL_GO="${CURRENT_PATH}/trigger-vs.el"

socket_file=""
TMP_VALUE_FILE="${CURRENT_PATH}/__tmp/vv"
:> "${TMP_VALUE_FILE}"
get_socket_file()
{
    lsof -c Emacs | grep server | tr -s " " | cut -d' ' -f8 > "${TMP_VALUE_FILE}"
    if [ -f "${TMP_VALUE_FILE}" ]
    then
        socket_file="$(sed -n '$p' "${TMP_VALUE_FILE}")"
    fi

}
get_socket_file

is_emacs_alive=""
get_emacs_is_live()
{
    local r="$(ps aux | grep -i "/Applications/5.app/Contents/MacOS/Emacs" | grep -v grep)"
    if [ "${r}" != "" ]
    then
        # Emacs已经打开
        is_emacs_alive="true"
    fi
}
get_emacs_is_live

emacs="/Applications/5.app"
emacsclient="/Applications/5.app/Contents/MacOS/bin/emacsclient"

fChar="${1}"
fPath="${2}"

# say 1
go_init()
{
    # 如果打开的是项目文件夹
    if [ "${fChar}" == "isdir" ]
    then
        fChar="-1"
    fi

cat << MOMO > "${EL_GO}"
;; 打开文件或者文件夹
(momo-evs "${fPath}" ${fChar} t)
(provide 'trigger-vs)
MOMO

    # 启动emacs
    open -a "${emacs}"
}


evs_value_file_momo="/Users/momo/.emacs.d/taotao-plugin-settings/evs/evs-emacs/__tmp/v"
go_client()
{
    local isConnect=""
    if [ "${fPath}" != "" ] && [ "${fChar}" != "" ]
    then
        # 可以读取到参数
        if [ "${fChar}" != "isdir" ]
        then
            # 打开文件，这里是位置跳转
            if [ "${socket_file}" != "" ]
            then
                "${emacsclient}" -n -e "(momo-evs \"${fPath}\" ${fChar})" --socket-name "${socket_file}"
                isConnect="$?"
            else
                "${emacsclient}" -n -e "(momo-evs \"${fPath}\" ${fChar})"
                isConnect="$?"
            fi
        fi
    fi

    # 打开Emacs
    if [ "${isConnect}" != 0 ] || [ "${fPath}" != "" ]
    then
        open -a "${emacs}"
    else
        "${emacsclient}" -n "${fPath}"
    fi

}


go()
{
    # 当前是否有emacs的服务，已经emacs是否打开
    if [ "${socket_file}" == "" ]
    then
        if [ "${is_emacs_alive}" == "" ]
        then
            # emacs没打开，执行elisp代码逻辑
            go_init
        else
            # emacs打开了，走的是client
            go_client
        fi
    else
        # 执行shell代码逻辑（走的是client）
        go_client
    fi
}
go
