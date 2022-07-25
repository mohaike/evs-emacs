# VSCode内部调用，结束的回调
CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
VSCODE_WHERE_ARE_YOU_C="${1}"
VSCODE_GET_VALUE_FILE="${CURRENT_PATH}/__tmp/vscode_get_value"
VSCODE_YOU_SHOULD_BE_HERE="${CURRENT_PATH}/__tmp/vscode_you_should_be_here"

# 非Debug模式输出日志
is_debug_mode="t"
mLog()
{
    if [ "${is_debug_mode}" != "" ]
    then
        echo "${1}"
    fi
}

# 检测VSCode是否抵达
is_vscode_get()
{
    VSCODE_YOU_SHOULD_BE_HERE_C="$(cat "${VSCODE_YOU_SHOULD_BE_HERE}")"
    if [ "${VSCODE_WHERE_ARE_YOU_C}" == "${VSCODE_YOU_SHOULD_BE_HERE_C}" ]
    then
        # 到了
        echo 0
    else
        # 没到
        echo 1
    fi
}

go()
{
    v_get="$(is_vscode_get)"
    c_time="$(date +"%Y-%m-%d %H:%M:%S")"
    if [ $v_get == 0 ]
    then
        # 清空VSCode读取的位置文件
        :> "${VSCODE_GET_VALUE_FILE}"
        mLog "[${c_time}][on vscode finish]已经抵达！"
    else
        mLog "[on vscode finish]或是异步"
    fi

    echo

}
go
