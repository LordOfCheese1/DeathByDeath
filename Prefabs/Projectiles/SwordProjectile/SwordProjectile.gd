extends Area2D


var speed = 300
var is_dead = false


func _ready():
	if Values.lowe_specs:
		$ParticleSpawner.wait_time = 0.1
		$ParticleSpawner/Timer.wait_time = $ParticleSpawner.wait_time
	look_at(get_global_mouse_position())
	$ParticleSpawner.spawn_at = get_parent()


func _physics_process(delta):
	position += (transform.x * speed) * delta


func _on_SwordProjectile_body_entered(body):
	if !body.is_in_group("player"):
		destroy()


func destroy():
	randomize()
	$Hit.pitch_scale = rand_range(0.8, 1.2)
	$Hit.play(0.0)
	if !is_dead:
		is_dead = true
		speed = 0
		$AnimationPlayer.play("Death")
		yield(get_tree().create_timer(0.1, false), "timeout")
		$Attackbox.call_deferred("free")
		yield(get_tree().create_timer(0.23, false), "timeout")
		call_deferred("free")


func _on_Attackbox_on_attack():
	destroy()
