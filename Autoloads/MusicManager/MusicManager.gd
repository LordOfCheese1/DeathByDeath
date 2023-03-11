extends AudioStreamPlayer


func _ready():
	pass


func _switch_track(new_track : String, save_as_new = true):
	volume_db = 0
	if save_as_new:
		Values.user_values["current_music"] = new_track
	for i in range(20):
		volume_db -= 1
		yield(get_tree().create_timer(0.02), "timeout")
	stream = load(new_track)
	play()
	pitch_scale = 1
	for i in range(20):
		volume_db += 1
		yield(get_tree().create_timer(0.02), "timeout")
	volume_db = 0


func _on_MusicManager_finished():
	stream = load(Values.user_values["current_music"])
	play()
