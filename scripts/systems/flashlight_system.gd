extends Node3D

@onready var head: Node3D = $"../head"
@onready var m_camera: Camera3D = $"../head/m_camera"
@onready var flashlight: SpotLight3D = $flashlight
@onready var flashlight_timer: Timer = $flashlight_timer

@export var smooth_factor : float = 10.0
@export var stream : AudioStream

var can_turn_on = true

var audio_player : AdaptiveAudioPlayer

func _ready() -> void:
	flashlight_timer.timeout.connect(func(): can_turn_on = true)
	
	audio_player = SoundManager._create_3d_sfx("Flashlight")
	audio_player.stream = stream
	audio_player.autoplay = false
	
	add_child(audio_player)

func _process(delta: float) -> void:
	if not GameManager.has_flashlight: return
	
	_switch()
	_follow(delta)

func _switch() -> void:
	if Input.is_action_just_pressed("flashlight") && can_turn_on:
		flashlight.visible = !flashlight.visible
		audio_player.play_sfx()
		flashlight_timer.start()
		can_turn_on = false

func _follow(delta : float) -> void:
	flashlight.global_position = head.global_position
	flashlight.global_rotation.x = lerp_angle(flashlight.global_rotation.x, head.global_rotation.x, smooth_factor * delta)
	flashlight.global_rotation.y = lerp_angle(flashlight.global_rotation.y, head.global_rotation.y, smooth_factor * delta)
