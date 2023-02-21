extends Area2D


var y_velocity = 50


func _ready():
	$AnimationPlayer.play("Poop")
	$Attackbox.add_to_group("enemy")
	yield(get_tree().create_timer(1.2, false), "timeout")
	$AnimationPlayer.play("Break")
	$Attackbox.call_deferred("free")
	yield(get_tree().create_timer(0.3, false), "timeout")
	call_deferred("free")


func _physics_process(delta):
	$Sprite.rotation_degrees += 1
	position.y += y_velocity * delta
	y_velocity += 3


func _on_Egg_body_entered(body):
	if !body.is_in_group("player") && !body.is_in_group("enemy") && body == TileMap:
		$AnimationPlayer.play("Break")
		$Attackbox.call_deferred("free")
		yield(get_tree().create_timer(0.3, false), "timeout")
		call_deferred("free")
