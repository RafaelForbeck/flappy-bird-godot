extends Node2D

signal point_scored

func _ready() -> void:
	add_to_group("Pipes")

func _process(delta: float) -> void:
	position.x += GameManager.speed * delta
	if position.x < -400:
		queue_free()

func _on_score_area_body_entered(body: Node2D) -> void:
	emit_signal("point_scored")
