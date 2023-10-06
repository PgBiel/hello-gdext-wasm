use godot::prelude::*;
use godot::engine::Sprite2D;
use godot::engine::Sprite2DVirtual;

#[derive(GodotClass)]
#[class(base=Sprite2D)]
struct Player {
    speed: f64,
    angular_speed: f64,

    #[base]
    sprite: Base<Sprite2D>
}

#[godot_api]
impl Sprite2DVirtual for Player {
    fn init(sprite: Base<Sprite2D>) -> Self {
        godot_print!("Hello, world!"); // Prints to the Godot console

        Self {
            speed: 400.0,
            angular_speed: std::f64::consts::PI,
            sprite
        }
    }

    fn physics_process(&mut self, delta: f64) {
        // In GDScript, this would be:
        // rotation += angular_speed * delta

        self.sprite.rotate((self.angular_speed * delta) as f32);
        // The 'rotate' method requires a f32,
        // therefore we convert 'self.angular_speed * delta' which is a f64 to a f32
    }
}
