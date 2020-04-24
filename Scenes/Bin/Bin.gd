extends Area2D

signal junk_collected
signal wrong_color

export var red: bool = true setget set_red
export var green: bool = true setget set_green
export var blue: bool = true setget set_blue

func _on_Bin_body_entered(body):
	if body.is_in_group("junk"):
		if body.get_color() == $Sprite.modulate and not body.dormant:
			emit_signal("junk_collected")
			body.queue_free()
		elif not body.dormant:
			emit_signal("wrong_color")
			body.queue_free()

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
