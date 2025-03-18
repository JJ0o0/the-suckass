extends VBoxContainer

@onready var config: VBoxContainer = $"../config"
@onready var confirmation_screen: PanelContainer = $"../confirmation_screen"

var state : bool = false
var animate : bool = false

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

func _on_btn_start_pressed() -> void:
	pass

func _on_btn_config_pressed() -> void:
	_hide()
	config._show()

func _on_btn_exit_pressed() -> void:
	confirmation_screen._show()
