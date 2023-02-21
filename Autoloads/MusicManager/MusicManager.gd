extends AudioStreamPlayer


func _ready():
	play()


func _switch_track(new_track : String):
	for i in range(20):
		volume_db -= 1
		yield(get_tree().create_timer(0.02), "timeout")
	stream = load(new_track)
	for i in range(20):
		volume_db += 1
		yield(get_tree().create_timer(0.02), "timeout")


func _process(delta):
	if !playing:
		play()
