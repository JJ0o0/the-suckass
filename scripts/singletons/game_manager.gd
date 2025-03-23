extends Node

var main : Node
var scenes : Array[PackedScene]

var player : CharacterBody3D
var enemy : CharacterBody3D

var dialogue_obj : Node3D

var hud : Control

var click_sound : AudioStream = preload("res://addons/kenney_ui_audio/click4.wav")
var dialogue_audios : Dictionary[String, Array] = {
	"narrator" : [
		preload("res://sounds/voices/narrator/key (1).wav"), 
		preload("res://sounds/voices/narrator/key (2).wav"), 
		preload("res://sounds/voices/narrator/key (3).wav"),
		preload("res://sounds/voices/narrator/key (4).wav"),
		preload("res://sounds/voices/narrator/key (5).wav"),
		preload("res://sounds/voices/narrator/key (6).wav")
		],
	"player": [
		preload("res://sounds/voices/protagonist_talk.wav")
		]
	}

var collectables : Array = []
var collected : Array = []

var dialogue_duration : float

var dialogue : String
var dialogue_subject : String

var dialogue_mode : bool = false
var dialogue_writing : bool = false
var dialogue_mode_move_camera : bool = true
var last_dialogue : bool = true
var debug_mode : bool = false

# https://forum.godotengine.org/t/how-to-get-all-children-from-a-node/18587/3
func _get_all_children(node : Node, arr:=[]):
	arr.push_back(node)
	
	for child in node.get_children():
		arr = _get_all_children(child,arr)
	
	return arr
