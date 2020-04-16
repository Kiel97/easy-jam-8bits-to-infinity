extends Area2D

signal shard_collected
#signal wrong_color

func _on_Bin_body_entered(body):
	if body.is_in_group("shard"):
		emit_signal("shard_collected")
		body.queue_free()
