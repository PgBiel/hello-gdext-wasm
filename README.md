# hello-gdext-wasm
Rust `gdext` wasm test project

Expects Godot v4.4.x.

## Setup

Please check https://godot-rust.github.io/book/toolchain/export-web.html for the latest instructions on exporting to web.

This project is ready for usage, but needs some additional setup on your side:

1. Ensure you have nightly cargo installed through `rustup`
    - Also ensure you install the following components:
        ```sh
        rustup toolchain install nightly
        rustup component add rust-src --toolchain nightly
        rustup target add wasm32-unknown-emscripten --toolchain nightly
        ```

2. Ensure you have emsdk v3.1.73
    - If you don't have it, you may follow these steps:
      1. Go to a directory where to install it
      2. `git clone https://github.com/emscripten-core/emsdk.git`
      3. `cd emsdk`
      4. `./emsdk install 3.1.73`
      5. `./emsdk activate 3.1.73`
      6. `source ./emsdk_env.sh`
      7. Confirm with `emcc --version`

3. Come back to this project's root folder with `cd`, and run `cd rust` to access the Rust folder
4. Run `./build-wasm.sh` to build the Rust code
    - By default, this will build both single- and multi-threaded variants so the "Thread Support" checkbox in the Godot editor works regardless of whether it's on or off.
    - **Note:** cargo may ask you to run a rustup command to fetch the Rust standard library's source code.
      - If prompted with a suggested `rustup` command, make sure to run it.
5. You can now open the `godot/` folder in the Godot editor and attempt to export to the web.
    - **First-time setup:** create export presets (and download export templates if needed)
      1. Go to Project > Export... at the top toolbar
      2. If export templates are missing, use the button to download them
      3. Click "Add..." to add a new preset
      4. Select "Web"
      5. Enable "Extensions Support"
      6. (Optional) Enable "Thread Support" (should work with or without)
      7. Choose an Export Path (e.g. `/home/user/Godot/wasmtest/index.html`)
      8. Press "Export project" to test it

## Exporting to the web

Latest instructions can be found at https://godot-rust.github.io/book/toolchain/export-web.html.

1. Compile with `cd rust && ./build-wasm.sh`
2. Export at Project > Export... > Web > Export Project
3. To test your exported web project, press "Remote deploy > Run in Browser" near the run button at the top
