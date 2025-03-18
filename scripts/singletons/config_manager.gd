extends Node

const PATH = "user://settings.ini"

var file = ConfigFile.new()

var defaults = {
	"Video": {
		"Quality" : "High",
		"Fullscreen" : true,
		"Vsync" : false
	},
	"Audio": {
		"MasterVolume" : 100,
		"MusicVolume" : 100,
		"SFXVolume" : 100
	}
}

func _ready() -> void:
	if not FileAccess.file_exists(PATH):
		for s in defaults:
			var dic = defaults[s] # dick??
			for k in dic:
				file.set_value(s, k, dic[k])
		
		file.save(PATH)

func _save(section : String, setting_name : String, value) -> void:
	if section != "Video" or section != "Audio":
		return
	
	file.set_value(section, setting_name, value)
	file.save(PATH)

func _load(section : String) -> Dictionary:
	if section != "Video" or section != "Audio":
		return {}
	
	var s = {}
	for k in file.get_section_keys(section):
		s[k] = file.get_value(section, k)
	
	return s

func _load_to_default() -> void:
	file.clear()
	
	for s in defaults:
		var dic = defaults[s] # dick??
		for k in dic:
			file.set_value(s, k, dic[k])
		
		file.save(PATH)
