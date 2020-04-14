extends KinematicBody2D

const ACC_ERROR_MARGIN = 0.1
const AXIS_Y_CORRECTION = 3

var velocity

func _process(_delta):
	var acc: Vector3 = Input.get_accelerometer()
	
	velocity = Vector2(round(acc.x), round(-(acc.y+AXIS_Y_CORRECTION)))
	
	velocity = move_and_collide(velocity.normalized() * sqrt(3))
