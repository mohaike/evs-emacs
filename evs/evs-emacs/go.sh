#!/bin/sh

CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
VALUE_FILE="${CURRENT_PATH}/__tmp/v"
alias TOOL="sh ${CURRENT_PATH}/core-char.sh"

source "${VALUE_FILE}"

go()
{
    TOOL "${emacs_char_index}" "${current_filePath}"
}
go
