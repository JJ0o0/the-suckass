extends PanelContainer

@onready var pause: VBoxContainer = $pause
@onready var config: VBoxContainer = $config
@onready var confirmation_screen: PanelContainer = $confirmation_screen

var duration : float

var state : bool = false
var finished : bool = true

var sfx_player

func _ready() -> void:
	visible = get_tree().paused
	
	sfx_player = SoundManager._create_sfx("PauseMenu")
	
	add_child(sfx_player)
	
	for i in GameManager._get_all_children(self):
		if i is Button:
			i.mouse_entered.connect(func(): 
				sfx_player.stream = GameManager.click_sound
				sfx_player.play()
			)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not get_tree().paused:
			_pause()
		else:
			_unpause()
	
	#region Animação
	if finished:
		return
	
	duration = 5.0 * delta
	
	var target : Color = Color(1.0, 1.0, 1.0, 1.0) if state else Color(1.0, 1.0, 1.0, 0.0)
	modulate = lerp(modulate, target, duration)
	
	if modulate.is_equal_approx(target):
		visible = state
		get_tree().paused = state
		finished = true
	#endregion

func _pause() -> void:
	get_tree().paused = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	_show()

func _unpause() -> void:
	get_tree().paused = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	_hide()

func _show() -> void:
	show()
	
	SoundManager._stop_all_audio_players()
	
	state = true
	finished = false

func _hide() -> void:
	state = false
	finished = false

func _on_btn_resume_pressed() -> void:
	if not get_tree().paused:
		return
	
	_unpause()

func _on_btn_menu_pressed() -> void:
	confirmation_screen._show()

func _disable_all_buttons() -> void:
	for i in GameManager._get_all_children(self):
		if i is Button:
			i.disabled = true

func _on_animation_timer_timeout() -> void:
	for i in GameManager._get_all_children(self):
		if i is Button:
			i.disabled = false

func _on_btn_options_pressed() -> void:
	pause._hide()
	config._show()
