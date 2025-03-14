extends Node

@onready var interaction_raycast: RayCast3D = $"../head/m_camera/interaction_raycast"

func _process(delta: float) -> void:
	if GameManager.dialogue_mode:
		return
	
	_detect_interaction(delta)

func _detect_interaction(delta : float) -> void:
	if interaction_raycast.is_colliding():
		var obj = interaction_raycast.get_collider()
		
		if obj.is_in_group("interactable"):
			GameManager.hud._change_interaction_text(obj.prompt)
			GameManager.hud._toggle_label(true, delta)
			GameManager.hud._toggle_crosshair(true)
			
			if Input.is_action_just_pressed("interact"):
				obj._interact()
	else:
		GameManager.hud._toggle_label(false, delta)
		GameManager.hud._toggle_crosshair(false)
