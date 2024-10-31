extends Node2D

enum GameState { TITLE, PLAYING, GAMEOVER }

signal enter_title()
signal enter_playing()
signal enter_game_over()

@onready var restart_timer := $RestartTimer
@onready var title_node := $Title
@onready var game_over_node := $GameOver
@onready var score_label := $ScoreLabel
@onready var hi_score_label := $HiScoreLabel

@export var speed = -150.0

var status := GameState.TITLE
var can_restart = false
var score = 0
var hi_score = 0

func _ready() -> void:
	#saver = Saver.loa
	go_to_title()

func _physics_process(delta: float) -> void:
	match status:
		GameState.TITLE:
			warmup()
		GameState.PLAYING:
			playing()
		GameState.GAMEOVER:
			game_over()

func go_to_title():
	status = GameState.TITLE
	GameManager.speed = speed
	can_restart = false
	title_node.visible = true
	game_over_node.visible = false
	score_label.visible = false
	if hi_score > 0:
		hi_score_label.visible = true
	else:
		hi_score_label.visible = false
	score = 0
	update_score_label()
	emit_signal("enter_title")

func go_to_playing():
	status = GameState.PLAYING
	title_node.visible = false
	score_label.visible = true
	hi_score_label.visible = false
	emit_signal("enter_playing")

func go_to_game_over():
	status = GameState.GAMEOVER
	GameManager.speed = 0
	restart_timer.start()
	game_over_node.visible = true
	if score > hi_score:
		hi_score = score
	hi_score_label.visible = true
	update_hi_score_label()
	emit_signal("enter_game_over")

func warmup():
	if Input.is_action_just_pressed("jump"):
		go_to_playing()

func playing():
	pass

func game_over():
	if Input.is_action_just_pressed("jump") and can_restart:
		go_to_title()

func _on_bird_rigid_body_2d_game_over() -> void:
	go_to_game_over()
	
func _on_character_body_2d_game_over() -> void:
	go_to_game_over()

func _on_restart_timer_timeout() -> void:
	can_restart = true

func _on_pipes_spawner_point_scored() -> void:
	add_score()
	
func add_score():
	score += 1
	update_score_label()

func update_score_label():
	score_label.text = str(score)

func update_hi_score_label():
	hi_score_label.text = str("HI-SCORE: ", hi_score)
