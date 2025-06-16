#!/bin/sh
cd "$(dirname $0)"
set -e

# Multithreaded wasm
RUSTFLAGS="-C link-args=-pthread \
-C target-feature=+atomics \
-C link-args=-sSIDE_MODULE=2 \
-Zlink-native-libraries=no \
-Cllvm-args=-enable-emscripten-cxx-exceptions=0" EM_CACHE=$(mktemp -d) cargo +nightly build \
  --features godot/experimental-wasm,godot/lazy-function-tables \
  -Zbuild-std --target wasm32-unknown-emscripten $@

mv target/wasm32-unknown-emscripten/debug/coolbeans.wasm target/wasm32-unknown-emscripten/debug/a.wasm || true

# Single-threaded wasm
EM_CACHE=$(mktemp -d) cargo +nightly build \
  --features nothreads,godot/experimental-wasm,godot/lazy-function-tables \
  -Zbuild-std --target wasm32-unknown-emscripten $@
