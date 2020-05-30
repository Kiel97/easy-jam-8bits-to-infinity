class_name Player
extends RigidBody2D

const MOUSE_FOLLOW_SPEED: float = 2.4
const ACC_FOLLOW_SPEED: float = 24.0

export var red: bool = true setget _set_red
export var green: bool = true setget _set_green
export var blue: bool = true setget _set_blue

var during_game: bool = false

var _velocity: Vector2
var _acc_y_correction: float = 0.0

onready var os_name: String = OS.get_name()
onready var sprite := $Sprite as Sprite
onready var bounce_sfx := $BounceSound as AudioStreamPlayer

func _integrate_forces(state: Physics2DDirectBodyState):
	if (during_game):
		if _is_mobile_device():
			var acc: Vector3 = Input.get_accelerometer()
			state.linear_velocity = Vector2(acc.x, -(acc.y)) * ACC_FOLLOW_SPEED
			state.linear_velocity.y -= _acc_y_correction
		else:
			var mouse_pos: Vector2 = get_global_mouse_position()
			var distance_x: float = (round(mouse_pos.x - self.position.x))
			var distance_y: float = (round(mouse_pos.y - self.position.y))
			
			_velocity = Vector2(distance_x, distance_y)
			state.linear_velocity = _velocity * MOUSE_FOLLOW_SPEED
	else:
		state.linear_velocity = Vector2.ZERO

func _is_mobile_device():
	return os_name in ['Android', 'iOS']
		
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
	sprite.modulate = Color(float(red), float(green), float(blue))

func _on_Player_body_entered(_body: Node2D):
	if (during_game):
		bounce_sfx.play()
