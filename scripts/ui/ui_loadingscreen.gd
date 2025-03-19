extends Node

@onready var loading_timer: Timer = $loading_timer

@export var target_scene_index : int = 2

func _on_loading_timer_timeout() -> void:
	GameManager.main._change_scene(GameManager.scenes[target_scene_index])
	queue_free()
