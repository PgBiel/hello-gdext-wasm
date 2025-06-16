#!/bin/sh
cd "$(dirname $0)"

# Multithreaded wasm
RUSTFLAGS="-C link-args=-pthread" EM_CACHE=$(mktemp -d) cargo +nightly build \
  --features godot/experimental-wasm,godot/lazy-function-tables \
  -Zbuild-std --target wasm32-unknown-emscripten $@

mv target/debug/coolbeans.wasm target/debug/coolbeans.threads.wasm

# Single-threaded wasm
EM_CACHE=$(mktemp -d) cargo +nightly build \
  --features nothreads,godot/experimental-wasm,godot/lazy-function-tables \
  -Zbuild-std --target wasm32-unknown-emscripten $@
