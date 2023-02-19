extends Area2D


func _ready():
	$AnimationPlayer.play("Spread")
	yield(get_tree().create_timer(0.8, false), "timeout")
	call_deferred("free")


func _on_Web_body_entered(body):
	if body.is_in_group("player"):
		body.velocity = Vector2(0, 0)
