extends RigidBody2D

const MOUSE_FOLLOW_SPEED = 1.2
const ACC_FOLLOW_SPEED = 22

const ACC_Y_CORRECTION = 0

var velocity

onready var os: String = OS.get_name()


func _integrate_forces(state):
	if (os == 'Android' or os == 'iOS'):
		var acc: Vector3 = Input.get_accelerometer()
		state.linear_velocity = Vector2(acc.x, -(acc.y+ACC_Y_CORRECTION)) * ACC_FOLLOW_SPEED
	else:
		var mouse_pos = get_global_mouse_position()
		var distance_x = (round(mouse_pos.x - self.position.x))
		var distance_y = (round(mouse_pos.y - self.position.y))
		velocity = Vector2(distance_x, distance_y)
		
		state.linear_velocity = velocity * MOUSE_FOLLOW_SPEED
