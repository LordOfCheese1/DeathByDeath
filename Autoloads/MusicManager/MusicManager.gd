extends AudioStreamPlayer


func _ready():
	play()


func _switch_track(new_track : String):
	for i in range(10):
		volume_db -= 2
		yield(get_tree().create_timer(0.03), "timeout")
	stream = load(new_track)
	for i in range(10):
		volume_db += 2
		yield(get_tree().create_timer(0.03), "timeout")


func _process(delta):
	if !playing:
		play()
