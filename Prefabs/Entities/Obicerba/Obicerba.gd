extends StaticBody2D


func _ready():
	pass


func _on_Hitbox_on_hit():
	$AnimationPlayer.play("Bounce")


func _on_Shield_shield_down():
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.3, false), "timeout")
	call_deferred("free")
