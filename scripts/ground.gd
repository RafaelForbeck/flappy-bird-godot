extends Node2D

func _physics_process(delta: float) -> void:
	position.x += GameManager.speed * delta
	
	if position.x < -24:
		position.x += 24
