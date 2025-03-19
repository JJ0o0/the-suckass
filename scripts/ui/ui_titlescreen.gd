extends VBoxContainer

@onready var config: VBoxContainer = $"../config"
@onready var confirmation_screen: PanelContainer = $"../confirmation_screen"
@onready var credits_screen: PanelContainer = $"../credits_screen"

var duration : float

var state : bool = false
var animate : bool = false

var init_show : bool

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	
	init_show = true
	
	_show()

func _process(delta: float) -> void:
	if not animate:
		return
	
	var target : Color = Color(1.0, 1.0, 1.0, 1.0) if state else Color(1.0, 1.0, 1.0, 0.0)
	self.modulate = lerp(self.modulate, target, duration)
	
	if self.modulate.is_equal_approx(target):
		self.visible = state
		animate = false

func _show() -> void:
	show()
	
	duration = 15.0 * get_process_delta_time() if not init_show else 0.5 * get_process_delta_time()
	
	%animation_timer.wait_time = duration
	%animation_timer.start()
	
	$"../.."._disable_all_buttons()
	
	animate = true
	state = true

func _hide() -> void:
	init_show = false
	
	duration = 15.0 * get_process_delta_time() if not init_show else 0.5 * get_process_delta_time()
	
	animate = true
	state = false

func _on_btn_start_pressed() -> void:
	GameManager.main._to_loading_screen(2)

func _on_btn_config_pressed() -> void:
	_hide()
	config._show()

func _on_btn_exit_pressed() -> void:
	confirmation_screen._show()

func _on_btn_credits_pressed() -> void:
	credits_screen._show()
