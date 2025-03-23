extends Node

@onready var video_stream_player: VideoStreamPlayer = $Control/VideoStreamPlayer

func _on_video_stream_player_finished() -> void:
	GameManager.main._change_scene(GameManager.scenes[0])
