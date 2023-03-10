extends Node2D


export var button_size : Vector2
export var texture : Texture
var mouse_is_on = false
signal pressed_ok


func _ready():
	$Sprite.texture = texture
	position.x = position.x + button_size.x / 2


func _physics_process(delta):
	if EnemyFunctions.distance(get_global_mouse_position(), position).x < button_size.x / 1.5 && EnemyFunctions.distance(get_global_mouse_position(), position).y < button_size.y / 1.5:
		$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(1.2, 1.2), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		mouse_is_on = true
	else:
		$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(1, 1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		mouse_is_on = false
	
	if mouse_is_on == true && Input.is_action_just_pressed("confirm"):
		emit_signal("pressed_ok")
