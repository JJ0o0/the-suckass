extends Node3D

@onready var footsteps_timer: Timer = $footsteps_timer
@onready var footsteps_ground: RayCast3D = $footsteps_ground

@export var dirt_footsteps_sounds : Array[AudioStream]
@export var grass_footsteps_sounds : Array[AudioStream]
@export var wood_footsteps_sounds : Array[AudioStream]
@export var footstep_interval : float = 1.0

var audio_player : AdaptiveAudioPlayer

var curr_sound : AudioStream
var curr_footsteps_sounds : Array[AudioStream]

var can_step : bool = true

func _ready() -> void:
	_setup()

func _process(delta : float) -> void:
	if not $".."._is_moving() || not $"..".is_on_floor():
		return
	
	if not can_step:
		return
	
	_identify_ground()
	_play_random_stream()

func _setup() -> void:
	footsteps_timer.wait_time = footstep_interval
	footsteps_timer.connect("timeout", _on_timer_timeout)
	
	audio_player = SoundManager._create_3d_sfx("Footsteps")
	
	add_child(audio_player)

func _play_random_stream() -> void:
	curr_sound = curr_footsteps_sounds.pick_random()
	
	audio_player.stream = curr_sound
	audio_player.play_sfx()
	
	footsteps_timer.start()
	can_step = false

func _identify_ground() -> void:
	if footsteps_ground.is_colliding():
		var obj = footsteps_ground.get_collider()
		
		if obj.is_in_group("ground_grass"):
			curr_footsteps_sounds = grass_footsteps_sounds
		elif obj.is_in_group("ground_dirt"):
			curr_footsteps_sounds = dirt_footsteps_sounds
		elif obj.is_in_group("ground_wood"):
			curr_footsteps_sounds = wood_footsteps_sounds
		else:
			curr_footsteps_sounds = grass_footsteps_sounds

func _on_timer_timeout() -> void:
	can_step = true
