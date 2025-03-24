extends StaticBody3D

@export_multiline var dialogue = "Hm, parece que a novela já acabou."
@export var prompt = "TV"
@export var move_camera : bool = true
@export var subject : String = "player"
@export var duration = 3.0

func _interact() -> void:
	GameManager.dialogue = dialogue
	GameManager.dialogue_mode_move_camera = move_camera
	GameManager.dialogue_obj = self
	GameManager.dialogue_subject = subject
	GameManager.dialogue_mode = true
	
	GameManager._change_dialogue_duration(duration)
	
	GameManager.hud._typewrite()
