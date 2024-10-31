extends RigidBody2D

enum PlayerState { WARMUP, FLYING, HURT }

signal game_over()

@onready var anim := $AnimatedSprite2D

@export var jump_force := -400.0
var status = PlayerState.WARMUP
var start_position := Vector2.ZERO

func _ready() -> void:
	start_position = position
	go_to_warmup()

func _physics_process(delta: float) -> void:
	match status:
		PlayerState.WARMUP:
			warmup()
		PlayerState.FLYING:
			flaying()
		PlayerState.HURT:
			hurt()

func go_to_warmup():
	status = PlayerState.WARMUP
	global_transform.origin = start_position
	gravity_scale = 0
	linear_velocity = Vector2.ZERO
	anim.play("flappy")

func go_to_flying():
	status = PlayerState.FLYING
	gravity_scale = 1
	jump()

func go_to_hurt():
	status = PlayerState.HURT
	jump()
	anim.play("hurt")

func warmup():
	pass

func flaying():
	if Input.is_action_just_pressed("jump"):
		jump()
	rotation = atan(linear_velocity.y / 1000)

func hurt():
	pass

func jump():
	linear_velocity.y = jump_force

func _on_body_entered(body: Node) -> void:
	if status != PlayerState.HURT:
		emit_signal("game_over")

func _on_game_enter_title() -> void:
	go_to_warmup()

func _on_game_enter_playing() -> void:
	go_to_flying()

func _on_game_enter_game_over() -> void:
	go_to_hurt()
