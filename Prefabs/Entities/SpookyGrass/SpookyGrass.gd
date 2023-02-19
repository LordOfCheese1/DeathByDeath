extends Node2D


var look_at_player = false


func _ready():
	$AnimationPlayer.play("Wiggle")
	$Sprite.rotation_degrees = 0


func _physics_process(delta):
	if look_at_player:
		$Sprite.look_at(Values.player.global_position)
		$Sprite.rotation_degrees = ($Sprite.rotation_degrees / 3) + (90 / 3)
		$Sprite.rotation_degrees = clamp($Sprite.rotation_degrees, -70, 70)


func _on_HealthManager_health_depleted():
	$AnimationPlayer.play("Cut")
	yield(get_tree().create_timer(0.3, false), "timeout")
	call_deferred("free")


func _on_VisibilityEnabler2D_screen_entered():
	show()
	look_at_player = true


func _on_VisibilityEnabler2D_screen_exited():
	hide()
	look_at_player = false
