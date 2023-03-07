extends Area2D


var speed = 130


func _ready():
	$Attackbox.add_to_group("enemy")


func _physics_process(delta):
	position += (transform.x * speed) * delta


func destroy():
	$AnimationPlayer.play("Decay")
	$CollisionShape2D.call_deferred("free")
	$Attackbox.call_deferred("free")
	yield(get_tree().create_timer(0.1, false), "timeout")
	yield(get_tree().create_timer(0.2, false), "timeout")
	call_deferred("free")


func _on_Attackbox_on_attack():
	destroy()
	$Attackbox.call_deferred("free")


func _on_DeathBullet_body_entered(body):
	if !body.is_in_group("enemy"):
		destroy()
