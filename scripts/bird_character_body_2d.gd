extends CharacterBody2D

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
			flaying(delta)
		PlayerState.HURT:
			hurt(delta)

func go_to_warmup():
	status = PlayerState.WARMUP
	position = start_position
	rotation = 0
	set_collision_mask_value(3, true)
	anim.play("flappy")

func go_to_flying():
	status = PlayerState.FLYING
	jump()

func go_to_hurt():
	status = PlayerState.HURT
	rotation = 0
	set_collision_mask_value(3, false)
	jump()
	anim.play("hurt")

func warmup():
	pass

func flaying(delta):
	velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump"):
		jump()
	
	rotation = atan(velocity.y / 1000)

	var collision = move_and_collide(velocity * delta)
	if collision != null:
		emit_signal("game_over")
	
func hurt(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity = Vector2.ZERO
		
	move_and_collide(velocity * delta)

func jump():
	velocity.y = jump_force

func _on_game_enter_title() -> void:
	go_to_warmup()

func _on_game_enter_playing() -> void:
	go_to_flying()

func _on_game_enter_game_over() -> void:
	go_to_hurt()
