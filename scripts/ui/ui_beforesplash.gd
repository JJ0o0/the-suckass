extends Node

@onready var video_stream_player: VideoStreamPlayer = $Control/VideoStreamPlayer

func _on_video_stream_player_finished() -> void:
	if GameManager.skip_intro:
		GameManager.main._play_static_scene_transition(GameManager.scenes[1], 0.65)
		
		return
	
	GameManager.main._change_scene(GameManager.scenes[0])
