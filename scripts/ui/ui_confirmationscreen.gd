extends PanelContainer

@export var exit_to_menu = false

var animate : bool = false

var state : bool = false

var duration

func _process(delta: float) -> void:
	if not animate:
		return
	
	var target : Color = Color(1.0, 1.0, 1.0, 1.0) if state else Color(1.0, 1.0, 1.0, 0.0)
	self.modulate = lerp(self.modulate, target, duration)
	
	if not self.modulate.is_equal_approx(target):
		return
	
	self.visible = state
	animate = false

func _show() -> void:
	show()
	
	duration = 15.0 * get_process_delta_time()
	
	%animation_timer.wait_time = duration
	%animation_timer.start()
	
	if exit_to_menu:
		$".."._disable_all_buttons()
	else:
		$"../.."._disable_all_buttons()
	
	animate = true
	state = true

func _hide() -> void:
	animate = true
	state = false

func _on_btn_confirm_pressed() -> void:
	if exit_to_menu:
		get_tree().paused = false
		
		GameManager.main._remove_pause_menu()
		GameManager.main._to_loading_screen(1)
		
		return
	
	get_tree().quit()

func _on_btn_back_pressed() -> void:
	_hide()
