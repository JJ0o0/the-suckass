extends Control

const TV_STATIC = preload("res://sounds/tv/tv_static.wav")

var audio_player

var ended : bool = false

func _ready() -> void:
	audio_player = SoundManager._create_sfx("Static")
	audio_player.stream = TV_STATIC
	
	add_child(audio_player)
	
	audio_player.play()
