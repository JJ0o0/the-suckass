extends VBoxContainer

@onready var page_control: HBoxContainer = $page_control

@onready var game_settings: VBoxContainer = $game_settings
@onready var video_settings: VBoxContainer = $video_settings
@onready var audio_settings: VBoxContainer = $audio_settings

@onready var lbl_page: Label = $page_control/lblPage

@onready var btn_dialogue_multiplier: Button = $game_settings/btnDialogueMultiplier
@onready var btn_view_fps: Button = $game_settings/btnViewFPS
@onready var btn_skip_intro: Button = $game_settings/btnSkipIntro

@onready var btn_sensivity: Button = $video_settings/btnSensivity
@onready var btn_fullscreen: Button = $video_settings/btnFullscreen
@onready var btn_vsync: Button = $video_settings/btnVsync

@onready var btn_master_volume: Button = $audio_settings/btnMasterVolume
@onready var btn_sfx_volume: Button = $audio_settings/btnSFXVolume
@onready var btn_music_volume: Button = $audio_settings/btnMusicVolume

@export var on_main_menu : bool = true

var curr_dialogue_multiplier : float
var viewfps_enabled : bool
var skipintro_enabled : bool

var curr_mouse_sensivity : float
var fullscreen_enabled : bool
var vsync_enabled : bool

var curr_master_volume : float
var curr_sfx_volume : float
var curr_music_volume : float

var runned_btn_check : bool = false

# Porque essa porra tá roxa.

func _ready() -> void:
	var g_settings = ConfigManager._load("game")
	curr_dialogue_multiplier = g_settings.dialogue_multiplier
	viewfps_enabled = g_settings.view_fps
	skipintro_enabled = g_settings.skip_intro
	
	var v_settings = ConfigManager._load("video")
	
	curr_mouse_sensivity = float(v_settings.mouse_sensivity)
	fullscreen_enabled = v_settings.fullscreen
	vsync_enabled = v_settings.vsync
	
	var a_settings = ConfigManager._load("audio")
	curr_master_volume = float(a_settings.master_volume)
	curr_sfx_volume = float(a_settings.sfx_volume)
	curr_music_volume = float(a_settings.music_volume)
	
	btn_dialogue_multiplier.set_text("[ VEL. DO DIÁLOGO: %.1fx ]" % curr_dialogue_multiplier)
	btn_view_fps.set_text("[ VER FPS: LIGADO ]" if viewfps_enabled else "[ VER FPS: DESLIGADO ]")
	btn_skip_intro.set_text("[ PULAR INTRO: LIGADO ]" if skipintro_enabled else "[ PULAR INTRO: DESLIGADO ]")
	
	btn_sensivity.set_text("[ SENSIBILIDADE: %d ]" % curr_mouse_sensivity)
	btn_fullscreen.set_text("[ TELA CHEIA: LIGADO ]" if fullscreen_enabled else "[ TELA CHEIA: DESLIGADO ]")
	btn_vsync.set_text("[ VSYNC: LIGADO ]" if vsync_enabled else "[ VSYNC: DESLIGADO ]")
	
	btn_master_volume.set_text("[ VOLUME PRINCIPAL: %d ]" % curr_master_volume)
	btn_sfx_volume.set_text("[ VOLUME DE SFX: %d ]" % curr_sfx_volume)
	btn_music_volume.set_text("[ VOLUME DA MÚSICA: %d ]" % curr_music_volume)
	
	if on_main_menu:
		_apply()

#region variaveis do negocio básico lá

var fullscreen : bool

var curr_page : int = 0

var state : bool = false
var animate : bool = false

var duration

#endregion
#region negocio básico BRUH
func _on_btn_back_pressed() -> void:
	if on_main_menu:
		$"../title"._show()
	else:
		$"../pause"._show()
	
	_hide()

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
	
	if on_main_menu:
		$"../.."._disable_all_buttons()
	else:
		$".."._disable_all_buttons()
	
	animate = true
	state = true

func _hide() -> void:
	animate = true
	state = false

func _show_curr_page() -> void:
	match curr_page:
		0:
			game_settings.show()
			video_settings.hide()
			audio_settings.hide()
			
			lbl_page.set_text("Jogo")
		1:
			game_settings.hide()
			video_settings.show()
			audio_settings.hide()
			
			lbl_page.set_text("Vídeo")
		2:
			game_settings.hide()
			video_settings.hide()
			audio_settings.show()
			
			lbl_page.set_text("Áudio")

func _on_btn_left_pressed() -> void:
	if curr_page != 0:
		curr_page -= 1
	else:
		curr_page = 2
	
	_show_curr_page()

func _on_btn_right_pressed() -> void:
	if curr_page != 2:
		curr_page += 1
	else:
		curr_page = 0
	
	_show_curr_page()
#endregion

func _apply() -> void:
	GameManager.dialogue_multiplier = curr_dialogue_multiplier
	GameManager.skip_intro = skipintro_enabled
	GameManager._change_sensivity(curr_mouse_sensivity)
	
	#region VIDEO
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
	
	SoundManager._change_volume(&"Master", curr_master_volume / 10)
	SoundManager._change_volume(&"SFX", curr_sfx_volume / 10)
	SoundManager._change_volume(&"Music", curr_music_volume / 10)
	
	ConfigManager._save("game", "dialogue_multiplier", GameManager.dialogue_multiplier)
	ConfigManager._save("game", "view_fps", viewfps_enabled)
	ConfigManager._save("game", "skip_intro", GameManager.skip_intro)
	
	ConfigManager._save("video", "mouse_sensivity", curr_mouse_sensivity)
	ConfigManager._save("video", "fullscreen", fullscreen_enabled)
	ConfigManager._save("video", "vsync", vsync_enabled)
	
	ConfigManager._save("audio", "master_volume", curr_master_volume)
	ConfigManager._save("audio", "music_volume", curr_music_volume)
	ConfigManager._save("audio", "sfx_volume", curr_sfx_volume)

#region JOGO
func _on_btn_view_fps_pressed() -> void:
	viewfps_enabled = !viewfps_enabled
	
	btn_view_fps.set_text("[ VER FPS: LIGADO ]" if viewfps_enabled else "[ VER FPS: DESLIGADO ]")

func _on_btn_dialogue_multiplier_pressed() -> void:
	curr_dialogue_multiplier = curr_dialogue_multiplier + 0.2 if curr_dialogue_multiplier < 1.8 else 1.0
	
	btn_dialogue_multiplier.set_text("[ VEL. DO DIÁLOGO: %.1fx ]" % curr_dialogue_multiplier)
	
func _on_btn_skip_intro_pressed() -> void:
	skipintro_enabled = !skipintro_enabled
	
	btn_skip_intro.set_text("[ PULAR INTRO: LIGADO ]" if skipintro_enabled else "[ PULAR INTRO: DESLIGADO ]")
#endregion
#region VIDEO
func _on_btn_fullscreen_pressed() -> void:
	fullscreen_enabled = !fullscreen_enabled
	
	btn_fullscreen.set_text("[ TELA CHEIA: LIGADO ]" if fullscreen_enabled else "[ TELA CHEIA: DESLIGADO ]")

func _on_btn_vsync_pressed() -> void:
	vsync_enabled = !vsync_enabled
	
	btn_vsync.set_text("[ VSYNC: LIGADO ]" if vsync_enabled else "[ VSYNC: DESLIGADO ]")

func _on_btn_sensivity_pressed() -> void:
	curr_mouse_sensivity = curr_mouse_sensivity + 1.0 if curr_mouse_sensivity < 10.0 else 1.0
	
	btn_sensivity.set_text("[ SENSIBILIDADE: %d ]" % curr_mouse_sensivity)
#endregion
#region AUDIO
func _on_btn_master_volume_pressed() -> void:
	curr_master_volume = curr_master_volume + 1.0 if curr_master_volume < 10.0 else 0.0
	
	btn_master_volume.set_text("[ VOLUME PRINCIPAL: %d ]" % curr_master_volume)

func _on_btn_sfx_volume_pressed() -> void:
	curr_sfx_volume = curr_sfx_volume + 1.0 if curr_sfx_volume < 10.0 else 0.0
	
	btn_sfx_volume.set_text("[ VOLUME DE SFX: %d ]" % curr_sfx_volume)

func _on_btn_music_volume_pressed() -> void:
	curr_music_volume = curr_music_volume + 1.0 if curr_music_volume < 10.0 else 0.0
	
	btn_music_volume.set_text("[ VOLUME DA MÚSICA: %d ]" % curr_music_volume)
#endregion
