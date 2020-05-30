class_name Bin
extends Area2D

signal junk_collected
signal wrong_color

export var red: bool = true setget set_red
export var green: bool = true setget set_green
export var blue: bool = true setget set_blue

var active: bool = true

onready var sprite := $Sprite as Sprite

func update_color():
	sprite.modulate = Color(float(red), float(green), float(blue))

func set_red(value: bool):
	red = value
	call_deferred("update_color")

func set_green(value: bool):
	green = value
	call_deferred("update_color")

func set_blue(value: bool):
	blue = value
	call_deferred("update_color")

func _on_Bin_body_entered(body: Node2D):
	if active:
		if body.is_in_group("junk"):
			var junk_body := body as Junk
			if not junk_body.dormant:
				if junk_body.get_color() == sprite.modulate:
					emit_signal("junk_collected")
				else:
					emit_signal("wrong_color")
				junk_body.queue_free()
