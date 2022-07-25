CURRENT_PATH="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
EMACS_HOME="${HOME}/.emacs.d"

CURRENT_EVS_DIR="${CURRENT_PATH}/evs"
CURRENT_EVS_FILE="${CURRENT_PATH}/taotao-evs-mode.el"

evs_file="${EMACS_HOME}/taotao-evs-mode.el"
evs_dir0="${EMACS_HOME}/taotao-plugin-settings"
evs_dir="${evs_dir0}/evs"


go()
{
    if [ -d "${evs_dir}" ]
    then
        rm -rf "${evs_dir}"
        mkdir -p "${evs_dir0}"
    fi
    cp -R "${CURRENT_EVS_DIR}" "${evs_dir}"
    cp "${CURRENT_EVS_FILE}" "${evs_file}"
}
go
