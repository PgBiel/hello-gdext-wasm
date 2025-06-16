use godot::classes::{Area2D, ISprite2D, Sprite2D};
use godot::prelude::*;

#[derive(GodotClass)]
#[class(base=Sprite2D)]
struct Player {
    speed: f64,
    angular_speed: f64,
    #[export]
    clickee: OnEditor<Gd<Area2D>>,

    base: Base<Sprite2D>,
}

#[godot_api]
impl Player {
    fn thing(&self) {
        godot_print!("Waiting!");
    }
}
#[godot_api]
impl ISprite2D for Player {
    fn init(base: Base<Sprite2D>) -> Self {
        godot_print!("Hello, world!"); // Prints to the Godot console

        Self {
            speed: 400.0,
            angular_speed: std::f64::consts::PI,
            clickee: OnEditor::default(),
            base,
        }
    }

    fn ready(&mut self) {
        godot_print!("I am ready.");
        let clickee = (*self.clickee).clone();

        // spawn a new async task
        godot::task::spawn(async move {
            godot_print!("Waiting!");
            // await a signal
            let _: () = Signal::from_object_signal(&clickee, "mouse_entered")
                .to_future()
                .await;

            godot_print!("Thanks for the mouse.");
        });
    }

    fn physics_process(&mut self, delta: f64) {
        // In GDScript, this would be:
        // rotation += angular_speed * delta

        let radians = (self.angular_speed * delta) as f32;
        self.base_mut().rotate(radians);
        // The 'rotate' method requires a f32,
        // therefore we convert 'self.angular_speed * delta' which is a f64 to a f32
    }
}
