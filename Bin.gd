extends Area2D

signal shard_collected
signal wrong_color

export var red: bool = true setget set_red
export var green: bool = true setget set_green
export var blue: bool = true setget set_blue

func _on_Bin_body_entered(body):
	if body.is_in_group("shard"):
		if body.get_color() == $Sprite.modulate:
			emit_signal("shard_collected")
		else:
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
