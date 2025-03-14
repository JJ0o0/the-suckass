extends StaticBody3D

var prompt = "collect"

signal collect

func _interact() -> void:
	GameManager.collected.append(self)
	GameManager.hud._change_collection_text()
	
	queue_free()
