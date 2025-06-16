mod player;

use godot::prelude::*;

struct MyExtension;

#[cfg(feature = "nothreads")]
#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {}

#[cfg(not(feature = "nothreads"))]
#[gdextension(wasm_binary = "coolbeans.threads.wasm")]
unsafe impl ExtensionLibrary for MyExtension {}
