extends RigidBody2D

const ACC_ERROR_MARGIN = 0.1
const AXIS_Y_CORRECTION = 3
const FOLLOW_SPEED = 1.2

var velocity

onready var os: String = OS.get_name()

#func _process(_delta):
#
#	if (os == 'Android' or os == 'iOS'):
#		var acc: Vector3 = Input.get_accelerometer()
#		velocity = Vector2(acc.x, -(acc.y+AXIS_Y_CORRECTION))
#		velocity = move_and_collide(velocity.normalized() * sqrt(3))
#	else: # Web
#		var mouse_pos = get_global_mouse_position()
#		var distance_x = (round(mouse_pos.x - self.position.x)) * FOLLOW_SPEED/100
#		var distance_y = (round(mouse_pos.y - self.position.y)) * FOLLOW_SPEED/100
#		velocity = Vector2(distance_x, distance_y)
#
#		velocity = move_and_collide(velocity)

func _integrate_forces(state):
	if (os == 'Android' or os == 'iOS'):
		pass
#		var acc: Vector3 = Input.get_accelerometer()
#		add_force(Vector2(0, 0), Vector2(acc.x, -acc.y))
	else:
		var mouse_pos = get_global_mouse_position()
		var distance_x = (round(mouse_pos.x - self.position.x))
		var distance_y = (round(mouse_pos.y - self.position.y))
		velocity = Vector2(distance_x, distance_y)
		
		state.linear_velocity = velocity * FOLLOW_SPEED
