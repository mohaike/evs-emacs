# VSCode内部调用
CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
VSCODE_GET_VALUE_FILE="${CURRENT_PATH}/__tmp/vscode_get_value"
cat "${VSCODE_GET_VALUE_FILE}"
