extends KinematicBody2D

const ACC_ERROR_MARGIN = 0.1
const AXIS_Y_CORRECTION = -4

var velocity

func _process(_delta):
	var acc: Vector3 = Input.get_accelerometer()
	if (abs(acc.x) < ACC_ERROR_MARGIN):
		acc.x = 0
	if (abs(acc.y) < ACC_ERROR_MARGIN):
		acc.y = 0
	
	velocity = Vector2(round(acc.x), round(-acc.y))
	
	velocity = move_and_collide(velocity.normalized() * sqrt(3))
