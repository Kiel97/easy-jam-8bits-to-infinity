extends Node2D

export var junks: Array = [load("res://Scenes/Junk/JunkDiamond.tscn")]

var _score: int = 0 setget _set_score
var _is_playing: bool = false setget _set_playing_state

var _blinks_new_score: int = 6
var _highscore: int = 0
var _highscore_file: File = File.new()
var _highscore_path: String = "user://gchiscore.txt"

var _score_string: String = "Score: %d"
var _highscore_string: String = "High: %d"

# Timers
onready var junk_timer := $JunkGenerator/JunkTimer as Timer
onready var score_timer := $CanvasLayer/ScoreGameLabel/ScoreLabelTimer as Timer 
onready var blink_timer := $CanvasLayer/MainOverlay/TopVBox/HighscoreLabel/OneBlinkTimer as Timer

# UI
onready var main_overlay := $CanvasLayer/MainOverlay as Control
onready var tap_button := $CanvasLayer/MainOverlay/TapButton as TextureButton
onready var tap_label := $CanvasLayer/MainOverlay/MidVBox/TapLabel as Label
onready var title_label := $CanvasLayer/MainOverlay/TopVBox/TitleLabel as Label
onready var score_label := $CanvasLayer/MainOverlay/TopVBox/ScoreLabel as Label
onready var hiscore_label := $CanvasLayer/MainOverlay/TopVBox/HighscoreLabel as Label
onready var credits_overlay := $CanvasLayer/CreditsOverlay as Control
onready var score_game_label := $CanvasLayer/ScoreGameLabel as Label

# Sound effects
onready var music := $Music as AudioStreamPlayer
onready var menu_click_sfx := $MenuClickSound as AudioStreamPlayer
onready var collected_sfx := $CollectedSound as AudioStreamPlayer
onready var lose_sfx := $LoseSound as AudioStreamPlayer
onready var new_highscore_sfx := $NewHighscoreSound as AudioStreamPlayer

# Other
onready var spawn_point := $JunkGenerator/JunkPath/JunkPathSpawner as PathFollow2D
onready var player := $Player as Player
onready var junk_container := $Junk as Node2D
onready var bin_container := $Bins as Node2D

func _ready():
	randomize()
	score_game_label.visible = false
	credits_overlay.visible = false
	main_overlay.visible = true
	self._is_playing = false
	_load_highscore()
	assert(junks.size() >= 1)
	music.play()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_mouse_button_pressed(BUTTON_LEFT) and _is_playing:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _set_playing_state(value: bool):
	_is_playing = value
	if not _is_playing:
		junk_timer.autostart = false
		junk_timer.stop()
		player.during_game = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_set_bins_status(false)
	else:
		junk_timer.autostart = true
		junk_timer.start()
		player.during_game = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		_set_bins_status(true)

func _new_game():
	for junk in junk_container.get_children():
		junk.queue_free()
	self._score = 0
	main_overlay.visible = false
	get_viewport().warp_mouse(player.position)
	self._is_playing = true

func _spawn_random_junk():
	spawn_point.offset = randi()
	var junk := junks[randi() % junks.size()].instance() as Junk
	junk_container.add_child(junk)
	
	var direction: float = spawn_point.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	
	junk.position = spawn_point.position
	junk.rotation = direction
	junk.randomize_color()

func _game_over():
	self._is_playing = false
	main_overlay.visible = true
	_update_highscore()
	
	for junk in junk_container.get_children():
		junk.during_game = false
	
	score_label.text = _score_string % _score

func _set_score(value: int):
	_score = value
	score_game_label.text = str(_score)
	if _is_playing:
		_show_score()

func _show_score():
	score_game_label.visible = true
	score_timer.start()

func _hide_score():
	score_game_label.visible = false

func _load_highscore():
	if not _highscore_file.file_exists(_highscore_path):
		_highscore = 0
		_highscore_file.open(_highscore_path, File.WRITE)
		_highscore_file.store_string(str(_highscore))
		_highscore_file.close()
	
	_highscore_file.open(_highscore_path, File.READ)
	_highscore = int(_highscore_file.get_as_text())
	_highscore_file.close()
	
	hiscore_label.text = _highscore_string % _highscore

func _update_highscore():
	if _score > _highscore:
		_highscore = _score
		
		_highscore_file.open(_highscore_path, File.WRITE)
		_highscore_file.store_string(str(_highscore))
		_highscore_file.close()
		
		new_highscore_sfx.play()
		_blink_highscore_label()
	else:
		lose_sfx.play()
	
	hiscore_label.text = _highscore_string % _highscore

func _set_bins_status(status: bool):
	for bin in bin_container.get_children():
		bin.active = status

func _blink_highscore_label():
	for i in range(_blinks_new_score):
		hiscore_label.visible = not hiscore_label.visible
		blink_timer.start()
		yield(blink_timer, "timeout")

func _on_Bin_junk_collected():
	self._score += 1
	collected_sfx.play()

func _on_Bin_wrong_color():
	_game_over()

func _on_CreditsButton_pressed():
	menu_click_sfx.play()
	main_overlay.visible = false
	credits_overlay.visible = true

func _on_JunkTimer_timeout():
	_spawn_random_junk()

func _on_MusicButton_pressed():
	if music.playing:
		music.stop()
	else:
		music.play()

func _on_ScoreLabelTimer_timeout():
	_hide_score()

func _on_TapButton_pressed():
	menu_click_sfx.play()
	_new_game()

func _on_TapCreditsButton_pressed():
	menu_click_sfx.play()
	credits_overlay.visible = false
	main_overlay.visible = true
