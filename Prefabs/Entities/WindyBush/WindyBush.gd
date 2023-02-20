extends Node2D


func _ready():
	yield(get_tree().create_timer(rand_range(0, 1)), "timeout")
	$AnimationPlayer.play("Float")


func _on_Hitbox_on_hit():
	$AnimationPlayer.play("Cut")
	yield(get_tree().create_timer(0.3, false), "timeout")
	call_deferred("free")
