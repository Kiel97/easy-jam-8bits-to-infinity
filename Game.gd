extends Node2D

var score: int = 0
var is_playing: bool = true setget playing

export var junks: Array = [load("res://Shard.tscn")]

func _ready():
	randomize()
	get_viewport().warp_mouse($Player.position)

func _on_Bin_shard_collected():
	score += 1
	print("Score: ", score)

func _on_Bin_wrong_color():
	print("Game over")
	if ($Player):
		$Player.queue_free()
		self.is_playing = false
	print("Your score is: ", score)

func _on_JunkTimer_timeout():
	$JunkGenerator/JunkPath/JunkPathSpawner.offset = randi()
	var junk = junks[randi() % junks.size()].instance()
	$Junk.add_child(junk)
	var direction = $JunkGenerator/JunkPath/JunkPathSpawner.rotation + PI / 2
	junk.position = $JunkGenerator/JunkPath/JunkPathSpawner.position
	direction += rand_range(-PI / 4, PI / 4)
	junk.rotation = direction
	junk.randomize_color()

func playing(value):
	is_playing = value
	if not is_playing:
		$JunkGenerator/JunkTimer.autostart = false
		$JunkGenerator/JunkTimer.stop()
	else:
		$JunkGenerator/JunkTimer.autostart = true
		$JunkGenerator/JunkTimer.start()
