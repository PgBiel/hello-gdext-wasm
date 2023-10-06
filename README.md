# hello-gdext-wasm
Rust `gdext` wasm test project

## Setup

(Full info at https://gist.github.com/PgBiel/ffa695a479ef4466cb24755db983950b)

1. Ensure you have nightly cargo installed through `rustup`
  - E.g. `rustup toolchain install nightly`
2. Add the following to `~/.cargo/config.toml`:

```toml
rustflags = [
    "-C", "target-feature=+atomics,+bulk-memory,+mutable-globals",
]

[unstable]
build-std = ["panic_abort", "std"]
```

The above will ensure the Rust standard library will be buit whenever using a nightly toolchain.
This is necessary to use the flags listed above while compiling the standard library.

3. Ensure you have emsdk v3.1.45
  - If you don't have it, you may follow these steps:
    1. Go to a directory where to install it
    2. `git clone https://github.com/emscripten-core/emsdk.git`
    3. `cd emsdk`
    4. `./emsdk install 3.1.45`
    5. `./emsdk activate 3.1.45`
    6. `source ./emsdk_env.sh`
    7. Confirm with `emcc --version`

4. Come back to this project's root folder with `cd`, and run `cd rust`
5. Run `cargo +nightly build --target wasm32-unknown-emscripten` to build the Rust code
  - **Note:** cargo may ask you to run a rustup command to fetch the Rust standard library's source code.
If prompted with a suggested `rustup` command, make sure to run it.
6. You can now open the `godot/` folder in the Godot editor and attempt to export to the web.
