extends Sprite


var rot_velocity = 0
signal clawed


func _ready():
	pass



func _physics_process(delta):
	rot_velocity += 0.3 * position.x / 16
	rotation_degrees += rot_velocity
	if rot_velocity < -10 or rot_velocity > 10:
		rot_velocity = 0
	


func _on_FloorDetectorR_body_entered(body):
	if body.name[0] != "C":
		if rotation_degrees > 0:
			rot_velocity = -6
		emit_signal("clawed")


func _on_FloorDetectorL_body_entered(body):
	if body.name[0] != "C":
		if rotation_degrees < 0:
			rot_velocity = 6
		emit_signal("clawed")
