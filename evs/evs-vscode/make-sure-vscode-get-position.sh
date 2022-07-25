#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
VSCODE_WHERE_ARE_YOU="${CURRENT_PATH}/__tmp/vscode_where_are_you"
VSCODE_YOU_SHOULD_BE_HERE="${CURRENT_PATH}/__tmp/vscode_you_should_be_here"
IS_CHECK_NOW="${CURRENT_PATH}/__tmp/is_check_now"

VS_CODE_GO="${CURRENT_PATH}/__tmp/vs_code_go"
VS_CODE_STOP="${CURRENT_PATH}/__tmp/vs_code_stop"




mPath="${1}"
mLine="${2}"
mColumn="${3}"

emacs="/Applications/5.app"

# 检测VSCode是否抵达
is_vscode_get()
{

    local t1="$(stat -c %Y ${VS_CODE_GO})"
    local t2="$(stat -c %Y ${VS_CODE_STOP})"
    if [ "${t2}" -gt "${t1}" ]
    then
        # 到了
        echo 0
    else
        # 没到
        echo 1
    fi



    # VSCODE_WHERE_ARE_YOU_C="$(cat "${VSCODE_WHERE_ARE_YOU}")"
    # VSCODE_YOU_SHOULD_BE_HERE_C="$(cat "${VSCODE_YOU_SHOULD_BE_HERE}")"
    # if [ "${VSCODE_WHERE_ARE_YOU_C}" == "${VSCODE_YOU_SHOULD_BE_HERE_C}" ]
    # then
    #     # 到了
    #     echo 0
    # else
    #     # 没到
    #     echo 1
    # fi
}

# 非Debug模式输出日志
is_debug_mode=""
mLog()
{
    if [ "${is_debug_mode}" != "" ]
    then
        echo "${1}"
    fi
}

# 切Emacs
wakeup_emacs_active()
{
    open -a "${emacs}"
}

# 切VSCode
wakeup_vscode_active()
{
    open -b com.microsoft.VSCode "${mPath}"
}

# 唤起VSCode
wakeup_vscode_call()
{
    local wait_time="${1}"

    mLog "makesure time ${wait_time}"
    # code -g "${mPath}":"${mLine}":"${mColumn}"
    # code "${mPath}"
    # cliclick kp:arrow-right
    # cliclick kp:arrow-left
    # 然后会触发VSCode内部的改变选中状态，这样我们内置的指令就能达成了？
}


check_vscode_state()
{

    # sleep 0.4
    # # 直接给补上
    # cliclick kp:arrow-right

        # 每隔0.1秒检测一次
    # 检测50次，就是5秒

    # 什么类型的检测
    local max_wait_time="30"         # 最大执行次数
    local wait_time="0"              # 统计执行的次数
    local exe_success="false"        # 一开始没有执行，是运行失败的

    local v_get=""
    until "${exe_success}" != "true"
    do
        sleep 0.2


        ((wait_time++))

        # 检测是否光标到达目标位置，没有的话就开始推进一下
        v_get="$(is_vscode_get)"
        if [ $v_get == 0 ]
        then
            mLog "makesure get already get it!"
            exe_success="true"
            rm -rf "${IS_CHECK_NOW}"

            # # 超过0.5秒，说明需要手动激活一下VSCode
            # if [ $wait_time -gt 5 ]
            # then
            #     wakeup_vscode_active
            # fi
        else
            # 超过0.5秒没有抵达，就开始触发
            # 没抵达，又在特定时间，就催促一下
            # 用切换App的方式触发一下
            if [ $wait_time -lt 2 ]
            then
                wakeup_vscode_call "${wait_time}"
            fi
        fi


        if [[ "${wait_time}" -gt "${max_wait_time}" ]]
        then
            exe_success="true"
            rm -rf "${IS_CHECK_NOW}"
            mLog "检测VSCode状态超时"
            # wakeup_vscode_active
        fi
    done
}


go()
{
    if [ ! -f "${IS_CHECK_NOW}" ]
    then
        # 正在检测什么都不做，没有在检测就开始检测
        :>"${IS_CHECK_NOW}"
        check_vscode_state
    fi
}
go
