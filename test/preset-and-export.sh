#!/bin/sh

set -e

# utils
escape_cfg_string() {
    set -e

    echo "\"$(echo "$1" | sed -e 's/[\\"]/\\\0/g')\""
}

replace_cfg_placeholder() {
    set -e

    # https://stackoverflow.com/a/29613573
    replacement="$(echo "$2" | sed 's/[&/\]/\\&/g')"
    # We assume the placeholder is safe.
    # Replace from stdin directly.
    sed -e "s/{{{$1}}}/${replacement}/g"
}

# ---

godot=${GODOT_BIN:-godot}
if ! command -v "${godot}" >/dev/null 2>&1
then
    echo "Error: Godot command not found.
Ensure 'godot' is in your PATH, or specify the path to the Godot binary to use with the 'GODOT_BIN' environment variable."
    exit 1
fi

script_dir="$(realpath "$(dirname "$0")")"
project="$(realpath "${PROJECT_PATH:-godot}")"
export_threads="${EXPORT_THREADS_PATH:-${project}/.godot/threads/index.html}"
export_nothreads="${EXPORT_NOTHREADS_PATH:-${project}/.godot/nothreads/index.html}"
preset="${EXPORT_PRESET_NAME:-Preset}"
base_presets="${BASE_PRESETS_PATH:-${script_dir}/export_presets.base.cfg}"
shell="${HTML_SHELL:-${script_dir}/shell.html}"

real_presets=${project}/export_presets.cfg
backup_presets=${project}/export_presets.cfg.bup

echo "0. Preparing..."
echo "==============="
echo

cd "${project}"

if [ -e "${real_presets}" ]
then
    if ! mv "${real_presets}" "${backup_presets}"
    then
        echo "WARNING: Failed to backup current export presets. Stopping..."
        exit 1
    fi
fi

trap '[ -f "${backup_presets}" ] && echo "Killed, cleaning up..." && mv ${backup_presets} ${real_presets}' EXIT

copy_presets_with_threading() {
    set -e

    replace_cfg_placeholder "PRESET_NAME" "$(escape_cfg_string "${preset}")" \
    | replace_cfg_placeholder "THREAD_SUPPORT" "$1" \
    | replace_cfg_placeholder "CUSTOM_HTML_SHELL" "$(escape_cfg_string "${shell}")"
}

echo
echo "1. Exporting with threading..."
echo "=============================="
echo

copy_presets_with_threading "true" <"${base_presets}" >"${real_presets}"

mkdir -p "$(dirname "${export_threads}")"
${godot} --headless --export-debug "${preset}" "${export_threads}"

echo
echo "2. Exporting without threading..."
echo "================================="
echo

copy_presets_with_threading "false" <"${base_presets}" >"${real_presets}"
mkdir -p "$(dirname "${export_nothreads}")"
${godot} --headless --export-debug "${preset}" "${export_nothreads}"

echo
echo "3. Done, cleaning up."

[ -e "${backup_presets}" ] && mv "${backup_presets}" "${real_presets}"
