#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
VALUE_FILE="${CURRENT_PATH}/__tmp/emacs-call-me-value.sh"
VSCODE_GET_VALUE_FILE="${CURRENT_PATH}/__tmp/vscode_get_value"
VSCODE_YOU_SHOULD_BE_HERE="${CURRENT_PATH}/__tmp/vscode_you_should_be_here"
VSCODE_GET_VALUE_FILE_PATH="${CURRENT_PATH}/__tmp/vscode_get_value_file_path"
VS_CODE_GO="${CURRENT_PATH}/__tmp/vs_code_go"
VS_CODE_STOP="${CURRENT_PATH}/__tmp/vs_code_stop"
MOMO_COLLECT_POSITION="${CURRENT_PATH}/__tmp/momo_collect_position"

file_creator()
{
    if [ ! -f "${1}" ]
    then
        say 01
        :>"${1}"
    fi
}

go()
{
    mkdir -p "${CURRENT_PATH}/__tmp"
    file_creator "${VALUE_FILE}"
    file_creator "${VSCODE_GET_VALUE_FILE}"
    file_creator "${VSCODE_YOU_SHOULD_BE_HERE}"
    file_creator "${VSCODE_GET_VALUE_FILE_PATH}"
    file_creator "${VS_CODE_GO}"
    file_creator "${VS_CODE_STOP}"
    file_creator "${MOMO_COLLECT_POSITION}"
}
go
