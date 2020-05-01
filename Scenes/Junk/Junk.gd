extends RigidBody2D

export var red: bool = true setget set_red
export var green: bool = true setget set_green
export var blue: bool = true setget set_blue
export var textures_pool: Array = [load("res://Assets/Images/junk1.png")]

var AVAILABLE_COLORS = {
	"Red": [1, 0, 0],
	"Green": [0, 1, 0],
	"Blue": [0, 0, 1],
	"White": [1, 1, 1]
}

var dormant_velocity: Vector2
var dormant = true
var during_game: bool

func _ready():
	randomize()
	assert(textures_pool.size() >= 1)
	during_game = true
	choose_random_texture()
	apply_random_impulse()

func choose_random_texture(active: bool = true):
	if active:
		var texture = textures_pool[randi() % textures_pool.size()]
		$Polygon2D.texture = texture

func _integrate_forces(state):
	if not dormant:
		if state.linear_velocity.length() < 10:
			print("Dormant")
			dormant = true
			apply_random_impulse()

func _on_Junk_body_entered(body: Node2D):
	play_collision_sound()
	if body.is_in_group("player") and dormant:
		dormant = false

func set_red(value):
	red = value
	call_deferred("update_color")

func set_green(value):
	green = value
	call_deferred("update_color")

func set_blue(value):
	blue = value
	call_deferred("update_color")

func update_color():
	$Polygon2D.modulate = Color(float(red), float(green), float(blue))

func apply_random_impulse():
	apply_impulse(Vector2(), Vector2(rand_range(-45,45), rand_range(-45,45)))

func randomize_color():
	var chosen = AVAILABLE_COLORS.values()[randi() % AVAILABLE_COLORS.size()]
	self.red = chosen[0]
	self.green = chosen[1]
	self.blue = chosen[2]

func get_color() -> Color:
	return Color(float(red), float(green), float(blue))

func play_collision_sound():
	if (during_game):
		$CollisionSound.pitch_scale = rand_range(0.8, 1.2)
		$CollisionSound.play()
