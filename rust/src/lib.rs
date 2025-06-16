mod player;

use godot::prelude::*;

struct MyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for MyExtension {
    fn override_wasm_binary() -> Option<&'static str> {
        // Binary name unchanged (mycrate.wasm) without thread support
        #[cfg(feature = "nothreads")]
        return None;

        // Tell gdext we add a custom suffix to the binary with thread support
        // Please note that this is not needed if "mycrate.threads.wasm" is used
        // (you could return None as well in that particular case)
        #[cfg(not(feature = "nothreads"))]
        Some("a.wasm")
    }
}
