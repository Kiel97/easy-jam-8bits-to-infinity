extends RigidBody2D

export var red: bool = true setget set_red
export var green: bool = true setget set_green
export var blue: bool = true setget set_blue

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
