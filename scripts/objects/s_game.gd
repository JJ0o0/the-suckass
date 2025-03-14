extends Node3D

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var custcene_player: AnimationPlayer = $SubViewportContainer/SubViewport/custcene_player

@export var ambience : AudioStream

@export_multiline var initial_dialogues : Array[String]
@export var initial_dialogues_duration : Array[float]

var on_cutscene : bool = false
var i : int = 0

var ambient_audio_player

func _ready() -> void:
	# Tocar som ambiente
	ambient_audio_player = SoundManager._create_sfx("Ambience Night")
	
	sub_viewport.add_child(ambient_audio_player)
	
	ambient_audio_player.stream = ambience
	
	# Cutscene inicial
	custcene_player.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	if not on_cutscene:
		return
	
	if not GameManager.dialogue_mode:
		return
	
	if GameManager.dialogue_writing:
		return
	
	GameManager.last_dialogue = (i == initial_dialogues.size() - 1)
	GameManager.dialogue = initial_dialogues[i]
	GameManager.dialogue_duration = initial_dialogues_duration[i]
	
	if not GameManager.last_dialogue:
		i += 1
	
	GameManager.hud._typewrite()

func _on_animation_finished(anim_name) -> void:
	ambient_audio_player.play()
	on_cutscene = true
	
	match anim_name:
		"initial_cutscene":
			GameManager.dialogue_mode_move_camera = false
			
			GameManager.dialogue_subject = "player"
			GameManager.dialogue_mode = true
