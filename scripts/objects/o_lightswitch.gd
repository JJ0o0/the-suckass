extends StaticBody3D

@onready var player: AnimationPlayer = $player

@export var light : Light3D
@export var audio : AudioStream

var on = false

var prompt = "turn on"

var audio_player : AdaptiveAudioPlayer

func _ready() -> void:
	audio_player = SoundManager._create_3d_sfx("LightSwitch")
	
	add_child(audio_player)
	
	light.visible = false

func _play_sfx() -> void:
	audio_player.stream = audio
	audio_player.play_sfx()

func _interact() -> void:
	on = !on
	
	prompt = "turn off" if on else "turn on"
	
	light.visible = on
	
	if on:
		player.play("switch")
	else:
		player.play_backwards("switch")
