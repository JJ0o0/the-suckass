extends Control

@export var click_sound : AudioStream

var sfx_player

func _ready() -> void:
	sfx_player = SoundManager._create_sfx("TitleScreen")
	add_child(sfx_player)
	
	for i in _get_all_children(self):
		if i is Button:
			i.mouse_entered.connect(func(): 
				sfx_player.stream = click_sound
				sfx_player.play()
			)

# https://forum.godotengine.org/t/how-to-get-all-children-from-a-node/18587/3
func _get_all_children(node : Node, arr:=[]):
	arr.push_back(node)
	
	for child in node.get_children():
		arr = _get_all_children(child,arr)
	
	return arr
