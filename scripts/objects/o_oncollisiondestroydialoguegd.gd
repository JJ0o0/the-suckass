extends Area3D

@export_multiline var dialogue = ""
@export var target_obj : Node3D
@export var duration = 3.0
@export var move_camera : bool = true
@export var subject : String = "player"

func _ready() -> void:
	body_entered.connect(_show)

func _show(body : Node3D) -> void:
	if body is not CharacterBody3D:
		return
	
	GameManager.dialogue = dialogue
	GameManager.dialogue_mode_move_camera = move_camera
	GameManager.dialogue_obj = target_obj
	GameManager.dialogue_subject = subject
	GameManager.dialogue_mode = true
	GameManager.dialogue_duration = duration
	
	GameManager.hud._typewrite()
	
	queue_free()
