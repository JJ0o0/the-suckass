extends Node

@onready var splash_timer: Timer = $splash_timer
@onready var text_timer: Timer = $text_timer

@onready var labels: Control = $ui/labels

const INTRO_MUSIC : AudioStreamWAV = preload("res://musics/intro.wav")

var audio_player : AudioStreamPlayer

var was_visible : bool = false
var played : bool = false
var playing : bool = true

var text_count : int = 0

var target_visible : float = 1.0

var curr_lbl : RichTextLabel

func _ready() -> void:
	audio_player = SoundManager._create_music("IntroMusic")
	audio_player.stream = INTRO_MUSIC
	audio_player.finished.connect(func(): audio_player.play())
	
	add_child(audio_player)
	
	audio_player.play()
	
	for i in labels.get_children():
		i.visible_ratio = 0.0

func _process(delta: float) -> void:
	if text_count > labels.get_child_count() - 1:
		GameManager.main._play_static_scene_transition(GameManager.scenes[1], 0.65)
		
		return
	
	if not playing or played:
		return
	
	curr_lbl = labels.get_children()[text_count]
	curr_lbl.show()
	
	_play_tween(curr_lbl, 4.0 if text_count == 3 else 3.0)
	
	played = true

func _play_tween(lbl : RichTextLabel, duration) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(lbl, "visible_ratio", target_visible, duration)
	tween.finished.connect(func():
		lbl.visible = !is_equal_approx(lbl.visible_ratio, 0.0)
		
		text_timer.wait_time = 1.5 if target_visible == 1.0 else 1.0
		text_timer.start()
		playing = false
		played = false
	)

func _on_text_timer_timeout() -> void:
	target_visible = 0.0 if target_visible == 1.0 else 1.0
	
	text_count += 1 if not curr_lbl.visible else 0
	
	playing = true
