extends Node2D

var score: int = 0

const DEBUG_ACC = false

const ACC_ERROR_MARGIN = 0.1
const AXIS_Y_CORRECTION = 3

onready var accXlabel: Label = $CanvasLayer/ACCValues/X
onready var accYlabel: Label = $CanvasLayer/ACCValues/Y

func _ready():
	randomize()
	accXlabel.visible = OS.get_name() == 'Android' and DEBUG_ACC
	accYlabel.visible = OS.get_name() == 'Android' and DEBUG_ACC

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
	$Player.queue_free()
	print("Your score is: ", score)
