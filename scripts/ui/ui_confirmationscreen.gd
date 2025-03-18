extends PanelContainer

var animate : bool = false

var state : bool = false

func _process(delta: float) -> void:
	if not animate:
		return
	
	var target : Color = Color(1.0, 1.0, 1.0, 1.0) if state else Color(1.0, 1.0, 1.0, 0.0)
	self.modulate = lerp(self.modulate, target, 15.0 * delta)
	
	if not self.modulate.is_equal_approx(target):
		return
	
	self.visible = state
	animate = false

func _show() -> void:
	show()
	
	animate = true
	state = true

func _hide() -> void:
	animate = true
	state = false

func _on_btn_confirm_pressed() -> void:
	get_tree().quit()

func _on_btn_back_pressed() -> void:
	_hide()
