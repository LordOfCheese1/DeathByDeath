extends Node2D


func _ready():
	randomize()
	scale.x = rand_range(0.8, 1.2)
	scale.y = scale.x
	rotation_degrees = rand_range(0, 360)
	yield(get_tree().create_timer(0.5, false), "timeout")
	call_deferred("free")
