extends Control

@onready var fps_label: Label = $hud/fps_label
@onready var interaction_label: Label = $hud/interaction_label
@onready var dialogue_label: RichTextLabel = $hud/dialogue_label
@onready var crosshair: TextureRect = $hud/crosshair

@onready var dialogue_step: Timer = $dialogue_step

@export var crosshairs : Array[Texture]

var alpha : float = 0

var tween : Tween

var can_play : bool = true
var ended_line : bool = false
var audio_player : AudioStreamPlayer

var view_fps : bool

func _ready() -> void:
	var video_settings = ConfigManager._load("video")
	view_fps = video_settings.view_fps 
	
	GameManager.hud = self
	GameManager.main._add_pause_menu()
	
	audio_player = SoundManager._create_sfx("HUD")
	add_child(audio_player)

func _process(delta: float) -> void:
	if view_fps:
		fps_label.show()
		
		fps_label.set_text("FPS: " + str(int(Engine.get_frames_per_second())))
	else:
		fps_label.hide()
	
	if GameManager.dialogue_mode:
		_toggle_label(0.0, delta)
		
		if not ended_line and can_play:
			dialogue_step.wait_time = GameManager.dialogue_duration / (GameManager.dialogue_duration * 20)
			dialogue_step.start()
			can_play = false
		
		if Input.is_action_just_pressed("exit_dialogue"):
			if dialogue_label.visible_ratio < 1.0:
				_stop_typewrite()
				
				dialogue_label.show()
				dialogue_label.visible_ratio = 1.0
				return
			
			if not GameManager.last_dialogue && GameManager.dialogue_writing:
				_stop_typewrite()
				
				GameManager.dialogue_writing = false
				return
			
			GameManager.dialogue_mode = false
			_stop_typewrite()
		
		return
	
	if dialogue_label.visible:
		dialogue_label.hide()
	
	interaction_label.modulate = Color(1, 1, 1, alpha)

func _change_interaction_text(txt : String) -> void:
	if GameManager.dialogue_mode:
		return
	
	interaction_label.text = "[ " + txt + " ]"

func _typewrite() -> void:
	GameManager.dialogue_writing = true
	ended_line = false
	
	dialogue_label.show()
	dialogue_label.text = GameManager.dialogue
	dialogue_label.visible_ratio = 0.0
	
	tween = get_tree().create_tween()
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, GameManager.dialogue_duration)
	tween.finished.connect(func(): ended_line = true)

func _stop_typewrite() -> void:
	tween.stop()
	
	ended_line = true
	
	dialogue_label.hide()
	dialogue_label.visible_ratio = 0.0

func _toggle_label(value : bool, delta : float) -> void:
	if GameManager.dialogue_mode:
		alpha = 0.0
		
		interaction_label.modulate = Color(1, 1, 1, alpha)
		
		return
	
	alpha = lerp(interaction_label.modulate.a, 1.0 if value else 0.0, delta * 12.0)

func _toggle_crosshair(value : bool) -> void:
	crosshair.texture = crosshairs[1 if value else 0]

func _on_dialogue_check_timeout() -> void:
	var audio = GameManager.dialogue_audios[GameManager.dialogue_subject].pick_random()
	
	audio_player.stream = audio
	audio_player.play()
	audio_player.finished.connect(func(): can_play = true)
