extends Control

const MAIN_MENU_INITIAL = preload("res://musics/main_menu_initial.wav")
const MAIN_MENU_LOOP = preload("res://musics/main_menu_loop.wav")

@export var click_sound : AudioStream

var first_song : bool = true

var sfx_player
var music_player

func _ready() -> void:
	sfx_player = SoundManager._create_sfx("TitleScreen")
	music_player = SoundManager._create_music("TitleScreen")
	
	music_player.stream = MAIN_MENU_INITIAL
	music_player.finished.connect(func(): 
		if not first_song:
			return
		
		music_player.stream = MAIN_MENU_LOOP
		music_player.play()
		first_song = false
	)
	
	add_child(sfx_player)
	add_child(music_player)
	
	music_player.play()
	
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

func _disable_all_buttons() -> void:
	for i in _get_all_children(self):
		if i is Button:
			i.disabled = true

func _on_animation_timer_timeout() -> void:
	for i in _get_all_children(self):
		if i is Button:
			i.disabled = false
