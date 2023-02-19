extends Area2D


var speed = 300
var is_dead = false


func _ready():
	look_at(get_global_mouse_position())
	$ParticleSpawner.spawn_at = get_parent()


func _physics_process(delta):
	position += (transform.x * speed) * delta


func _on_SwordProjectile_body_entered(body):
	if !body.is_in_group("player"):
		destroy()


func destroy():
	if !is_dead:
		is_dead = true
		speed = 0
		$AnimationPlayer.play("Death")
		yield(get_tree().create_timer(0.2), "timeout")
		call_deferred("free")


func _on_Attackbox_on_attack():
	destroy()
