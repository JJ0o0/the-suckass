extends Node

var audio_players : Array = []
var playback_positions : Array = []

func _create_sfx(name : String) -> AudioStreamPlayer:
	var audio : AudioStreamPlayer = AudioStreamPlayer.new()
	audio.name = "AudioStreamPlayer - SFX_" + name
	audio.bus = &"SFX"
	
	audio_players.append(audio)
	
	return audio

func _create_music(name : String) -> AudioStreamPlayer:
	var audio : AudioStreamPlayer = AudioStreamPlayer.new()
	audio.name = "AudioStreamPlayer - MUSIC_" + name
	audio.bus = &"Music"
	
	audio_players.append(audio)
	
	return audio

func _create_3d_sfx(name : String) -> AdaptiveAudioPlayer:
	var audio : AdaptiveAudioPlayer = AdaptiveAudioPlayer.new()
	audio.name = "AdaptiveAudioPlayer - SFX_" + name
	audio.AAPAutoPlay = true
	audio.ContinuousAdapt = true
	audio.bus = &"SFX"
	
	audio_players.append(audio)
	
	return audio

func _stop_all_audio_players() -> void:
	for audio_player in audio_players:
		if audio_player == null:
			return
		
		audio_player.stop()

func _update_list() -> void:
	for audio_player in audio_players:
		if audio_player == null:
			audio_players.erase(audio_player)

func _change_volume(audio_bus : StringName, volume) -> void:
	var index = AudioServer.get_bus_index(audio_bus)
	
	AudioServer.set_bus_volume_db(index, linear_to_db(volume))
