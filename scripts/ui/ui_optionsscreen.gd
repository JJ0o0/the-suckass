extends VBoxContainer

@onready var page_control: HBoxContainer = $page_control
@onready var video_settings: VBoxContainer = $video_settings
@onready var audio_settings: VBoxContainer = $audio_settings
@onready var lbl_page: Label = $page_control/lblPage

@onready var btn_fullscreen: Button = $video_settings/btnFullscreen
@onready var btn_vsync: Button = $video_settings/btnVsync

@onready var title: VBoxContainer = $"../title"

var curr_quality : String
var fullscreen_enabled : bool
var vsync_enabled : bool

# Porque essa porra tá roxa.

func _ready() -> void:
	var settings = ConfigManager._load("Video")
	fullscreen_enabled = settings.Fullscreen
	vsync_enabled = settings.Vsync
	
	_apply()

#region variaveis do negocio básico lá

var fullscreen : bool

var curr_page : int = 0

var state : bool = false
var animate : bool = false

#endregion
#region negocio básico BRUH
func _on_btn_back_pressed() -> void:
	title._show()
	_hide()

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

func _show_curr_page() -> void:
	match curr_page:
		0:
			video_settings.show()
			audio_settings.hide()
			
			lbl_page.set_text("Vídeo")
		1:
			video_settings.hide()
			audio_settings.show()
			
			lbl_page.set_text("Áudio")

func _on_btn_left_pressed() -> void:
	curr_page = 0 if curr_page == 1 else 1
	
	_show_curr_page()

func _on_btn_right_pressed() -> void:
	curr_page = 1 if curr_page == 0 else 0
	
	_show_curr_page()
#endregion

func _apply() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if fullscreen_enabled else DisplayServer.WINDOW_MODE_WINDOWED
	)
	
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync_enabled else DisplayServer.VSYNC_DISABLED
	)

func _on_btn_fullscreen_pressed() -> void:
	fullscreen_enabled = !fullscreen_enabled
	
	btn_fullscreen.set_text("[ TELA CHEIA: LIGADO ]" if fullscreen_enabled else "[ TELA CHEIA: DESLIGADO ]")
	
	ConfigManager._save("Video", "Fullscreen", fullscreen_enabled)

func _on_btn_vsync_pressed() -> void:
	vsync_enabled = !vsync_enabled
	
	btn_vsync.set_text("[ VSYNC: LIGADO ]" if vsync_enabled else "[ VSYNC: DESLIGADO ]")
	
	ConfigManager._save("Video", "Vsync", vsync_enabled)

func _on_btn_quality_pressed() -> void:
	pass # Replace with function body.
