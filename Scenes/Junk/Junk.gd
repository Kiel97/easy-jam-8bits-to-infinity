class_name Junk
extends RigidBody2D

const COLORS : Dictionary = {
	"Red": [1, 0, 0],
	"Green": [0, 1, 0],
	"Blue": [0, 0, 1],
	"White": [1, 1, 1]
}

export var red: bool = true setget _set_red
export var green: bool = true setget _set_green
export var blue: bool = true setget _set_blue
export var textures_pool: Array = [load("res://Assets/Images/junk1.png")]

var dormant: bool = true
var during_game: bool

onready var polygon2D := $Polygon2D as Polygon2D
onready var collision_sfx := $CollisionSound as AudioStreamPlayer

func _ready():
	randomize()
	assert(textures_pool.size() >= 1)
	during_game = true
	_choose_random_texture()
	_apply_random_impulse()

func _integrate_forces(state: Physics2DDirectBodyState):
	if not dormant:
		if state.linear_velocity.length() < 10:
			dormant = true
			_apply_random_impulse()

func get_color() -> Color:
	return Color(float(red), float(green), float(blue))

func randomize_color():
	var chosen_color: Array = COLORS.values()[randi() % COLORS.size()]
	self.red = bool(chosen_color[0])
	self.green = bool(chosen_color[1])
	self.blue = bool(chosen_color[2])

func _apply_random_impulse():
	apply_impulse(Vector2(), Vector2(rand_range(-45,45), rand_range(-45,45)))

func _choose_random_texture(active: bool = true):
	if active:
		var texture := textures_pool[randi() % textures_pool.size()] as Texture
		polygon2D.texture = texture

func _play_collision_sound():
	if (during_game):
		collision_sfx.pitch_scale = rand_range(0.8, 1.2)
		collision_sfx.play()

func _set_red(value: bool):
	red = value
	call_deferred("_update_color")

func _set_green(value: bool):
	green = value
	call_deferred("_update_color")

func _set_blue(value: bool):
	blue = value
	call_deferred("_update_color")

func _update_color():
	polygon2D.modulate = Color(float(red), float(green), float(blue))

func _on_Junk_body_entered(body: Node2D):
	_play_collision_sound()
	if body.is_in_group("player") and dormant:
		dormant = false
