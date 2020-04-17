extends Node2D

var score: int = 0
var is_playing: bool = true setget playing

onready var spawn_point: PathFollow2D = $JunkGenerator/JunkPath/JunkPathSpawner
onready var junk_timer: Timer = $JunkGenerator/JunkTimer
onready var tap_button: TextureButton = $CanvasLayer/Control/TapButton

export var junks: Array = [load("res://Shard.tscn")]

func _ready():
	randomize()
	assert(junks.size() >= 1)
	$Player.visible = false

func _on_JunkTimer_timeout():
	spawn_point.offset = randi()
	var junk = junks[randi() % junks.size()].instance()
	$Junk.add_child(junk)
	var direction = spawn_point.rotation + PI / 2
	junk.position = spawn_point.position
	direction += rand_range(-PI / 4, PI / 4)
	junk.rotation = direction
	junk.randomize_color()

func playing(value):
	is_playing = value
	if not is_playing:
		junk_timer.autostart = false
		junk_timer.stop()
	else:
		junk_timer.autostart = true
		junk_timer.start()

func new_game():
	tap_button.visible = false
	for child in $Junk.get_children():
		child.queue_free()
	score = 0
	$Player.visible = true
	self.is_playing = true
	get_viewport().warp_mouse($Player.position)

func game_over():
	print("Game over")
	$Player.visible = false
	self.is_playing = false
	tap_button.visible = true
	print("Your score is: ", score)

func _on_TextureButton_pressed():
	new_game()

func _on_Bin_shard_collected():
	score += 1
	print("Score: ", score)

func _on_Bin_wrong_color():
	game_over()
