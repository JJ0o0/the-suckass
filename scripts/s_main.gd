extends Node

const LOADING_SCREEN = preload("res://scenes/ui/ui_loadingscreen.tscn")
const STATIC_SCENE_TRANSITION = preload("res://scenes/s_staticscenetransition.tscn")
const UI_PAUSE_MENU = preload("res://scenes/ui/ui_pause_menu.tscn")

@onready var s_beforesplash: Node = $SubViewportContainer/SubViewport/s_beforesplash
@onready var view: SubViewport = $SubViewportContainer/SubViewport
@export var scenes : Array[PackedScene]

var curr_scene : Node = null
var pause_menu : Node = null
var waiting_to_load : PackedScene = null
var transition_scene : Node = null

var _transition_ended : bool = true
var runned : bool = true

func _ready() -> void:
	_apply_settings()
	
	GameManager.main = self
	GameManager.scenes = scenes
	
	curr_scene = s_beforesplash

func _process(_delta: float) -> void:
	if runned:
		return
	
	if _transition_ended:
		var inst = waiting_to_load.instantiate()
		view.add_child(inst)
		
		curr_scene = inst
		
		waiting_to_load = null
		
		runned = true

func _apply_settings() -> void:
	var v_settings = ConfigManager._load("video")
	var fullscreen_enabled = v_settings.fullscreen
	var vsync_enabled = v_settings.vsync
	var view_fps_enabled = v_settings.view_fps
	
	var a_settings = ConfigManager._load("audio")
	var curr_master_volume = a_settings.master_volume
	var curr_sfx_volume = a_settings.sfx_volume
	var curr_music_volume = a_settings.music_volume
	
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if fullscreen_enabled else DisplayServer.WINDOW_MODE_WINDOWED
	)
	
	if not fullscreen_enabled:
		var screen_size = DisplayServer.screen_get_size()
		var half_screen_size = Vector2i(screen_size.x / 2, screen_size.y / 2)
		var window_size = Vector2i(screen_size.x / 1.5, screen_size.y / 1.5)
		get_window().set_size(window_size)
		
		DisplayServer.window_set_position(window_size - half_screen_size)
	
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync_enabled else DisplayServer.VSYNC_DISABLED
	)
	#endregion
	
	SoundManager._change_volume("Master", curr_master_volume / 10)
	SoundManager._change_volume("SFX", curr_sfx_volume / 10)
	SoundManager._change_volume("Music", curr_music_volume / 10)

func _play_static_scene_transition(scene : PackedScene, duration : float) -> void:
	curr_scene.queue_free()
	
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(func():
		_transition_ended = true
		
		transition_scene.queue_free()
		timer.queue_free()
	)
	
	add_child(timer)
	
	transition_scene = STATIC_SCENE_TRANSITION.instantiate()
	view.add_child(transition_scene)
	
	waiting_to_load = scene
	
	_transition_ended = false
	runned = false

func _to_loading_screen(next_scene_index : int) -> void:
	SoundManager._update_list()
	
	var loading_scene = LOADING_SCREEN.instantiate()
	loading_scene.target_scene_index = next_scene_index
	view.add_child(loading_scene)
	
	curr_scene.queue_free()

func _add_pause_menu() -> void:
	pause_menu = UI_PAUSE_MENU.instantiate()
	$CanvasLayer.add_child(pause_menu)

func _remove_pause_menu() -> void:
	if pause_menu == null:
		return
	
	pause_menu.queue_free()
	pause_menu = null

func _change_scene(scene : PackedScene) -> void:
	if curr_scene != null:
		curr_scene.queue_free()
		
		SoundManager._update_list()
	
	var ins = scene.instantiate()
	
	view.add_child(ins)
	
	curr_scene = ins
