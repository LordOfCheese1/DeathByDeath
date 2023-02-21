extends KinematicBody2D


var spotted_player = false
var velocity = Vector2(0, 0)


func _ready():
	$ParticleSpawner.spawn_at = get_parent()


func _process(delta):
	if EnemyFunctions.distance(Values.player.position, position).x < 128 && EnemyFunctions.distance(Values.player.position, position).y < 128 && !spotted_player:
		spotted_player = true
		$ParticleSpawner._start()
		$AnimationPlayer.play("Chase")


func _physics_process(delta):
	$Sprite.rotation_degrees = velocity.x / 2
	move_and_slide(velocity)
	if spotted_player:
		velocity += (Values.player.position - position) / 4
		velocity.x = clamp(velocity.x, -200, 200)
		velocity.y = clamp(velocity.y, -200, 200)


func _on_Hitbox_on_hit():
	velocity = -velocity


func _on_HealthManager_health_depleted():
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.5, false), "timeout")
	call_deferred("free")
