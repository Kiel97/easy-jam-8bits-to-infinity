extends Area2D

signal junk_collected
signal wrong_color

export var red: bool = true setget set_red
export var green: bool = true setget set_green
export var blue: bool = true setget set_blue

var active: bool = true

func set_red(value: bool):
	red = value
	call_deferred("update_color")

func set_green(value: bool):
	green = value
	call_deferred("update_color")

func set_blue(value: bool):
	blue = value
	call_deferred("update_color")

func update_color():
	$Sprite.modulate = Color(float(red), float(green), float(blue))

func _on_Bin_body_entered(body: Node2D):
	if active:
		if body.is_in_group("junk") and not body.dormant:
			if body.get_color() == $Sprite.modulate:
				emit_signal("junk_collected")
			else:
				emit_signal("wrong_color")
			body.queue_free()
