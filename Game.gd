extends Node2D

var score: int = 0 setget set_score
var is_playing: bool = false setget playing

var highscore: int = 0
var highscore_path: String = "user://gchiscore.txt"
var highscore_file: File = File.new()

onready var spawn_point: PathFollow2D = $JunkGenerator/JunkPath/JunkPathSpawner
onready var junk_timer: Timer = $JunkGenerator/JunkTimer
onready var score_timer: Timer = $CanvasLayer/ScoreGameLabel/ScoreLabelTimer

onready var main_overlay: Control = $CanvasLayer/MainOverlay
onready var tap_button: TextureButton = $CanvasLayer/MainOverlay/TapButton
onready var tap_label: Label = $CanvasLayer/MainOverlay/MidVBox/TapLabel
onready var title_label: Label = $CanvasLayer/MainOverlay/TopVBox/TitleLabel
onready var score_label: Label = $CanvasLayer/MainOverlay/TopVBox/ScoreLabel
onready var hiscore_label: Label = $CanvasLayer/MainOverlay/TopVBox/HighscoreLabel
onready var blink_timer: Timer = $CanvasLayer/MainOverlay/TopVBox/HighscoreLabel/OneBlinkTimer

onready var credits_overlay: Control = $CanvasLayer/CreditsOverlay

onready var score_game_label: Label = $CanvasLayer/ScoreGameLabel

export var junks: Array = [load("res://Junk.tscn")]

func _ready():
	randomize()
	self.is_playing = false
	print(OS.get_user_data_dir())
	load_highscore()
	assert(junks.size() >= 1)
	$Music.play()

func _on_JunkTimer_timeout():
	spawn_random_junk()

func playing(value):
	is_playing = value
	if not is_playing:
		junk_timer.autostart = false
		#$Player.visible = false
		junk_timer.stop()
		$Player.during_game = false
	else:
		junk_timer.autostart = true
		#$Player.visible = true
		junk_timer.start()
		$Player.during_game = true

func new_game():
	self.is_playing = true
	main_overlay.visible = false
	for child in $Junk.get_children():
		child.queue_free()
	self.score = 0
	get_viewport().warp_mouse($Player.position)
	
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		var y_correction := Input.get_accelerometer().y
		$Player.acc_y_correction = -y_correction

func set_score(value):
	score = value
	score_game_label.text = str(score)
	if is_playing:
		show_score()

func show_score():
	score_game_label.visible = true
	score_timer.start()

func hide_score():
	score_game_label.visible = false

func spawn_random_junk():
	spawn_point.offset = randi()
	var junk = junks[randi() % junks.size()].instance()
	$Junk.add_child(junk)
	var direction = spawn_point.rotation + PI / 2
	junk.position = spawn_point.position
	direction += rand_range(-PI / 4, PI / 4)
	junk.rotation = direction
	junk.randomize_color()

func game_over():
	print("Game over")
	self.is_playing = false
	main_overlay.visible = true
	print("Your score is: ", score)
	update_highscore()
	
	for junk in $Junk.get_children():
		junk.during_game = false
	
	score_label.text = "Score: " + str(score)

func load_highscore():
	if not highscore_file.file_exists(highscore_path):
		highscore = 0
		highscore_file.open(highscore_path, File.WRITE)
		highscore_file.store_string(str(highscore))
		highscore_file.close()
	
	highscore_file.open(highscore_path, File.READ)
	highscore = int(highscore_file.get_as_text())
	highscore_file.close()
	hiscore_label.text = "High: " + str(highscore)

func update_highscore():
	if score > highscore:
		highscore = score
		highscore_file.open(highscore_path, File.WRITE)
		highscore_file.store_string(str(highscore))
		highscore_file.close()
		$NewHighscoreSound.play()
		blink_highscore_label()
	else:
		$LoseSound.play()
	hiscore_label.text = "High: " + str(highscore)

func _on_TapButton_pressed():
	$MenuClickSound.play()
	new_game()

func _on_Bin_junk_collected():
	self.score += 1
	$CollectedSound.play()
	print("Score: ", score)

func _on_Bin_wrong_color():
	game_over()

func _on_CreditsButton_pressed():
	$MenuClickSound.play()
	main_overlay.visible = false
	credits_overlay.visible = true

func _on_ScoreLabelTimer_timeout():
	hide_score()

func _on_TapCreditsButton_pressed():
	$MenuClickSound.play()
	credits_overlay.visible = false
	main_overlay.visible = true

func blink_highscore_label():
	for i in range(6):
		hiscore_label.visible = not hiscore_label.visible
		blink_timer.start()
		yield(blink_timer, "timeout")
