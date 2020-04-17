extends RigidBody2D

const MOUSE_FOLLOW_SPEED = 2.4
const ACC_FOLLOW_SPEED = 24

var acc_y_correction = 0

var during_game = false
var velocity

export var red: bool = true setget set_red
export var green: bool = true setget set_green
export var blue: bool = true setget set_blue

onready var os: String = OS.get_name()

func _integrate_forces(state):
	if (during_game):
		if (os == 'Android' or os == 'iOS'):
			var acc: Vector3 = Input.get_accelerometer()
			state.linear_velocity = Vector2(acc.x, -(acc.y)) * ACC_FOLLOW_SPEED
			#state.linear_velocity.y -= acc_y_correction FIXME
		else:
			var mouse_pos = get_global_mouse_position()
			var distance_x = (round(mouse_pos.x - self.position.x))
			var distance_y = (round(mouse_pos.y - self.position.y))
			velocity = Vector2(distance_x, distance_y)
			
			state.linear_velocity = velocity * MOUSE_FOLLOW_SPEED
	else:
		state.linear_velocity = Vector2.ZERO
		
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
	$Sprite.modulate = Color(float(red), float(green), float(blue))

func _on_Player_body_entered(body):
	if (during_game):
		$BounceSound.play()
