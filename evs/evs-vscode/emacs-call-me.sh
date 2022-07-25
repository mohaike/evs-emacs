#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
VALUE_FILE="${CURRENT_PATH}/__tmp/emacs-call-me-value.sh"
VSCODE_GET_VALUE_FILE="${CURRENT_PATH}/__tmp/vscode_get_value"
VSCODE_YOU_SHOULD_BE_HERE="${CURRENT_PATH}/__tmp/vscode_you_should_be_here"
VSCODE_GET_VALUE_FILE_PATH="${CURRENT_PATH}/__tmp/vscode_get_value_file_path"
VS_CODE_GO="${CURRENT_PATH}/__tmp/vs_code_go"
VS_CODE_STOP="${CURRENT_PATH}/__tmp/vs_code_stop"

alias makeSureLineCloumnArrive="sh ${CURRENT_PATH}/make-sure-vscode-get-position.sh"

init()
{
    sh "${CURRENT_PATH}/evs-init.sh"
}
init

momo_code()
{
    local mPath="${1}"
    local mLine="${2}"
    local mColumn="${3}"
    local need_line_cloumn="${4}"


    # 检测是否打开了VSCode
    r="$(ps aux  | grep -i "/Applications/Visual Studio Code.app/Contents/Frameworks/Code Helper.app/Contents/MacOS/Code" | grep -v grep | grep -v "ms-enable-electron-run-as-node")"
    if [ "${r}" == "" ]
    then
        # VSCode还没打开，就开启

        # 用何种方式打开
        if [ "${need_line_cloumn}" != "" ]
        then
            # 需要行列跳转
            code -g "${mPath}":"${mLine}":"${mColumn}"
        else
            # 不需要行列跳转
            code "${mPath}"
        fi
    fi

    # 在已经打开VSCode的情况下，激活VSCode
    open -b com.microsoft.VSCode "${mPath}"

    # 标记一下时间
    :> "${VS_CODE_GO}"
    # 在VSCode已经打开的情况下检测是否抵达(做了优化不需要考虑这块)
    # if [ "${r}" != "" ]
    # then
    #     if [ "${need_line_cloumn}" != "" ]
    #     then
    #         # 有定位行列的需求才会监视是否抵达
    #         makeSureLineCloumnArrive "${mPath}" "${mLine}" "${mColumn}"
    #     fi
    # fi
}

# 格式化变量文件
format_value_file()
{
    sed 's/Char: " /Char: \\" /g' -i "${VALUE_FILE}"
}
format_value_file


go()
{

    source "${VALUE_FILE}"

    # 处理得到字符串号，保存起来待VSCode读取
    momo_char_position="${momo_char_position_o#*'point='}"
    momo_char_position="${momo_char_position%% *}"

    echo "${momo_char_position}" > "${VSCODE_GET_VALUE_FILE}.bak"


    # 行号列号
    momo_line_number="${momo_line_o#* }"
    momo_column_number="${momo_column_o#*'column='}"
    ((momo_column_number++))

     # 处理文件路径
    momo_path=""
    if [ -f "${momo_file_path_o}" ] || [ -d "${momo_file_path_o}" ]
    then
        # 如果是文件或者是目录就过
        momo_path="${momo_file_path_o}"
    else
        # 如果不是，说明被转意了，替换处理
        momo_path="${HOME}${momo_file_path_o#*'~'}"
    fi

    # 排除路径的麻烦
    if [ -d "${momo_path}" ]
    then
        momo_char_position="-1"
    fi

    # 分割的字符串，不用担心会有重复的路径...
    local split_str="[d0747b6a1bc6f5027a1c3d75f734dce21c0f205b15d54f6681e935a9298579a697264126d69ffb96]"
    # 传json太麻烦，直接用字符串拼接的方式吧...
    # 添加文件的路径，排除多线程的Bug
    local cmd_id="$(date +%s%N )" # 当前时间，纳秒级别，作为命令的时间戳
    local momoc_time="$(date +"%Y-%m-%d-%H:%M:%S")"
    local data_to_vscode="${momo_char_position}${split_str}${momo_path}${split_str}${cmd_id}${split_str}${momoc_time}"

    echo "${data_to_vscode}" > "${VSCODE_GET_VALUE_FILE}"
    sed -i 's/\n//g' "${VSCODE_GET_VALUE_FILE}"
    # 拷贝的校验文件
    cp "${VSCODE_GET_VALUE_FILE}" "${VSCODE_YOU_SHOULD_BE_HERE}"

    # 是否需要行和列的跳转
    local need_line_cloumn=""
    if [ -f "${momo_path}" ]
    then
        # 文件的话需要行列跳转
        need_line_cloumn="t"
    fi

    momo_code "${momo_path}" "${momo_line_number}" "${momo_column_number}" "${need_line_cloumn}"
}
go
