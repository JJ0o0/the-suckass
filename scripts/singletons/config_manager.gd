extends Node

const PATH = "user://settings.ini"

var file = ConfigFile.new()

var defaults = {
	"video": {
		"view_fps" : false,
		"fullscreen" : true,
		"vsync" : true
	},
	"audio": {
		"master_volume" : 10,
		"music_volume" : 10,
		"sfx_volume" : 10
	}
}

func _ready() -> void:
	if not FileAccess.file_exists(PATH):
		for s in defaults:
			var dic = defaults[s] # dick??
			for k in dic:
				file.set_value(s, k, dic[k])
		
		file.save(PATH)
	else:
		file.load(PATH)

func _save(section : String, setting_name : String, value) -> void:
	file.set_value(section, setting_name, value)
	file.save(PATH)

func _load(section : String):
	var sec = {}
	for key in file.get_section_keys(section):
		sec[key] = file.get_value(section, key)
	
	return sec
