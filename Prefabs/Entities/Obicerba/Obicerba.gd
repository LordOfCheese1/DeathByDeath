extends StaticBody2D


func _ready():
	pass


func _physics_process(delta):
	if Values.player.position.x > position.x:
		scale.x = -1
	else:
		scale.x = 1


func _on_Hitbox_on_hit():
	$AnimationPlayer.play("Bounce")


func _on_Shield_shield_down():
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.3, false), "timeout")
	call_deferred("free")
