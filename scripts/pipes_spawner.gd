extends Node2D

signal point_scored

@onready var timer := $Timer

var pipe_scene := preload("res://entities/pipes.tscn")
var random = RandomNumberGenerator.new()

func spawn_pipe():
	var new_pipe = pipe_scene.instantiate()
	new_pipe.add_to_group("Pipes")
	new_pipe.point_scored.connect(self.on_point_scored)
	new_pipe.position.y = random.randf_range(-80, 80)
	add_child(new_pipe)

func _on_timer_timeout() -> void:
	spawn_pipe()

func _on_game_enter_game_over() -> void:
	timer.stop()
	get_tree().call_group("Pipes", "stop")

func _on_game_enter_playing() -> void:
	spawn_pipe()
	timer.start(0)

func _on_game_enter_title() -> void:
	get_tree().call_group("Pipes", "queue_free")

func on_point_scored():
	emit_signal("point_scored")
