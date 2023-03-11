extends Node2D


func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -10)
	Engine.time_scale = 1
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


func _on_Fullscreen_pressed_ok():
	if !OS.window_fullscreen:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false


func _on_Quit_pressed_ok():
	if OS.get_name() != "HTML5":
		get_tree().quit()
