extends Node2D

var score: int = 0

const DEBUG_ACC = false

const ACC_ERROR_MARGIN = 0.1
const AXIS_Y_CORRECTION = 3

onready var accXlabel: Label = $CanvasLayer/ACCValues/X
onready var accYlabel: Label = $CanvasLayer/ACCValues/Y

export var junks: Array = [load("res://Shard.tscn")]

func _ready():
	randomize()
	accXlabel.visible = OS.get_name() == 'Android' and DEBUG_ACC
	accYlabel.visible = OS.get_name() == 'Android' and DEBUG_ACC
	get_viewport().warp_mouse($Player.position)

func _process(_delta):
	var acc: Vector3 = Input.get_accelerometer()
	
	if (OS.get_name() == 'Android' and DEBUG_ACC):
		accXlabel.text = "X: " + str(round(acc.x))
		accYlabel.text = "Y: " + str(round(-(acc.y + AXIS_Y_CORRECTION)))


func _on_Bin_shard_collected():
	score += 1
	print("Score: ", score)

func _on_Bin_wrong_color():
	print("Game over")
	if ($Player):
		$Player.queue_free()
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
#	junk.collision_mask = 11
#	yield(get_tree().create_timer(3.0), "timeout")
#	junk.collision_mask = 15
