#!/bin/sh
cd "$(dirname $0)"
set -e

# Multithreaded wasm
RUSTFLAGS="-C link-args=-pthread -C link-args=-sSIDE_MODULE=2 -C target-feature=+atomics,+bulk-memory,+mutable-globals -Zlink-native-libraries=no -Cllvm-args=-enable-emscripten-cxx-exceptions=0" EM_CACHE=$(mktemp -d) cargo +nightly build \
  --features godot/experimental-wasm,godot/lazy-function-tables \
  -Zbuild-std --target wasm32-unknown-emscripten $@

mv target/wasm32-unknown-emscripten/debug/coolbeans.wasm target/wasm32-unknown-emscripten/debug/coolbeans.threads.wasm || true

# Single-threaded wasm
EM_CACHE=$(mktemp -d) cargo +nightly build \
  --features nothreads,godot/experimental-wasm,godot/lazy-function-tables \
  -Zbuild-std --target wasm32-unknown-emscripten $@
