extends Area2D


var speed = 130
var destroy_wait_time = 120
var is_destroyed = false


func _ready():
	$Attackbox.add_to_group("enemy")


func _physics_process(delta):
	position += (transform.x * speed) * delta
	if destroy_wait_time > 0:
		destroy_wait_time -= 1
	else:
		if !is_destroyed:
			destroy()


func destroy():
	is_destroyed = true
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
	if body.is_in_group("player"):
		destroy()
