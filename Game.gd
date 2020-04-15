extends Node2D

const DEBUG_ACC = false

const ACC_ERROR_MARGIN = 0.1
const AXIS_Y_CORRECTION = 3

onready var accXlabel: Label = $CanvasLayer/ACCValues/X
onready var accYlabel: Label = $CanvasLayer/ACCValues/Y

func _ready():
	accXlabel.visible = OS.get_name() == 'Android' and DEBUG_ACC
	accYlabel.visible = OS.get_name() == 'Android' and DEBUG_ACC

func _process(_delta):
	var acc: Vector3 = Input.get_accelerometer()
	
	if (OS.get_name() == 'Android' and DEBUG_ACC):
		accXlabel.text = "X: " + str(round(acc.x))
		accYlabel.text = "Y: " + str(round(-(acc.y + AXIS_Y_CORRECTION)))
