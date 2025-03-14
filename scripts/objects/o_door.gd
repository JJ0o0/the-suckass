extends StaticBody3D

@onready var player: AnimationPlayer = $player

var opened : bool = false
var opening : bool = false

@export var locked : bool = false
@export var audios : Array[AudioStream]

var prompt = "open"

var audio_player : AdaptiveAudioPlayer

func _ready() -> void:
	audio_player = SoundManager._create_3d_sfx("Door")
	
	player.animation_finished.connect(func(anim_name): opening = false)
	
	add_child(audio_player)

func _play_door_sfx() -> void:
	var audio = audios[0 if opened else 1]
	
	audio_player.stream = audio
	audio_player.play_sfx()

func _interact() -> void:
	if opening:
		return
	
	if locked:
		prompt = "locked"
		
		return
	
	prompt = "close" if not opened else "open"
	
	if not opened:
		player.play("open")
	else:
		player.play_backwards("open")
	
	opened = !opened
	
	opening = true
