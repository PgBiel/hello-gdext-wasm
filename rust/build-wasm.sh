#!/bin/sh
cd "$(dirname $0)"
EM_CACHE=$(mktemp -d) cargo +nightly build \
  --features godot/experimental-wasm,godot/lazy-function-tables \
  -Zbuild-std --target wasm32-unknown-emscripten $@
