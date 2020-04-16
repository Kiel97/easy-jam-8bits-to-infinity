extends Node2D

var score: int = 0
var is_playing: bool = true setget playing

export var junks: Array = [load("res://Shard.tscn")]

func _ready():
	randomize()
	get_viewport().warp_mouse($Player.position)
	$Player.visible = false

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

func new_game():
	$CanvasLayer/Control/TextureButton.visible = false
	for child in $Junk.get_children():
		child.queue_free()
	score = 0
	$Player.visible = true
	is_playing = true

func game_over():
	print("Game over")
	$Player.visible = false
	self.is_playing = false
	$CanvasLayer/Control/TextureButton.visible = true
	print("Your score is: ", score)

func _on_TextureButton_pressed():
	new_game()

func _on_Bin_shard_collected():
	score += 1
	print("Score: ", score)

func _on_Bin_wrong_color():
	game_over()
