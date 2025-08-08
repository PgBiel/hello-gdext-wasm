#!/bin/sh

set -e
godot=${GODOT_BIN:-godot}
if ! command -v ${godot} >/dev/null 2>&1
then
    echo "Error: Godot command not found.
Ensure 'godot' is in your PATH, or specify the path to the Godot binary to use with the 'GODOT_BIN' environment variable."
    exit 1
fi

project=${PROJECT_PATH:-godot}
export=${EXPORT_PATH:-${project}/.godot/test/index.html}
preset=${EXPORT_PRESET:-Web}

cd ${project}
mkdir -p $(dirname ${export})
${godot} --headless --export-debug ${preset} ${export}
