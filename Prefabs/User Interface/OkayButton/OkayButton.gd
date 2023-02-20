extends Sprite


var mouse_is_on = false
signal pressed_ok
var pressable = true


func _ready():
	pass


func _physics_process(delta):
	if EnemyFunctions.distance(get_global_mouse_position(), position).x < 32 && EnemyFunctions.distance(get_global_mouse_position(), position).y < 16 && pressable:
		$Tween.interpolate_property(self, "scale", scale, Vector2(1.2, 1.2), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		mouse_is_on = true
	else:
		$Tween.interpolate_property(self, "scale", scale, Vector2(1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		mouse_is_on = false
	
	if mouse_is_on == true && Input.is_action_just_pressed("confirm"):
		pressable = false
		emit_signal("pressed_ok")
