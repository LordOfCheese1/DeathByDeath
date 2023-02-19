extends Area2D


func _ready():
	pass


func _on_BowPickup_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("Collect")
		yield(get_tree().create_timer(0.6, false), "timeout")
		Values.bow = true
		call_deferred("free")
