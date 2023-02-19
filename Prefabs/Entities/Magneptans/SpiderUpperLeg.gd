extends Sprite


var activated = false


func _ready():
	pass


func _physics_process(delta):
	if activated:
		look_at(Values.player.position)
		rotation_degrees = (rotation_degrees - 90)
		get_child(0).rotation_degrees = -rotation_degrees * (3 - (position.y / 6)) / 2
	else:
		activated = get_parent().get_parent().get_parent().activated
