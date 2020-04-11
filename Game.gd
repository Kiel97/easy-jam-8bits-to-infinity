extends Node2D

const DEBUG_ACC = false

const ACC_ERROR_MARGIN = 0.25
const ACC_MOVE_MULTIPLIER = 10

onready var accXlabel: Label = $CanvasLayer/ACCValues/X
onready var accYlabel: Label = $CanvasLayer/ACCValues/Y
onready var accZlabel: Label = $CanvasLayer/ACCValues/Z


func _ready():
	accXlabel.visible = DEBUG_ACC
	accYlabel.visible = DEBUG_ACC


func _process(delta):
	var acc: Vector3 = Input.get_accelerometer()
	if (abs(acc.x) < ACC_ERROR_MARGIN):
		acc.x = 0
	if (abs(acc.y) < ACC_ERROR_MARGIN):
		acc.y = 0
	$Sprite.translate(Vector2(acc.x, -acc.y) * delta * ACC_MOVE_MULTIPLIER)
	
	if (DEBUG_ACC):
		accXlabel.text = "X: " + str(stepify(acc.x, 0.001))
		accYlabel.text = "Y: " + str(stepify(acc.y, 0.001))
