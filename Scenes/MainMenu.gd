extends Node2D


func _ready():
	if !Values.user_values["load_on_start"]:
		MusicManager._switch_track("res://Audio/Music/MassKyrie.mp3")


func _on_Play_pressed_ok():
	Values.user_values["load_on_start"] = true
	Values.load_game()


func _on_DeleteSave_pressed_ok():
	Values.delete_file()


func _on_MuteMusic_pressed_ok():
	if !AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
