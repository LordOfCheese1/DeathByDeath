extends KinematicBody2D


var player
var is_hit = false
var is_dead = false
var velocity = Vector2()
var speed = 50
var accel = 10
var spotted_player
var gravity = 300


func _ready():
	$Hitbox.add_to_group("enemy")
	$Attackbox.add_to_group("enemy")
	$AnimationPlayer.play("Idle")


func _physics_process(delta):
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	if velocity.y < 300:
		velocity.y += gravity * delta
	
	if player == null && Values.player != null:
		player = Values.player
	
	if !is_dead:
		if !spotted_player:
			if EnemyFunctions.distance(position, player.position).x < 128 && EnemyFunctions.distance(position, player.position).y < 128:
				spotted_player = true
		else: #do this if spider is in player radius
			if player.position.x > position.x:
				walk(1)
				$Visuals.scale.x = 1
			else:
				walk(-1)
				$Visuals.scale.x = -1
			
			if player.position.y < position.y && player.is_on_floor():
				if is_on_floor():
					velocity.y = -80


func walk(dir : int):
	if !is_hit && !is_dead:
		$AnimationPlayer.play("Walk")
	velocity.x += (speed / accel) * dir
	velocity.x = clamp(velocity.x, -speed, speed)


func _on_Hitbox_on_hit():
	is_hit = true
	if player.position.x > position.x:
		velocity.x = -speed * 2
	elif player.position.x < position.x:
		velocity.x = speed * 2
	velocity.y = -120
	$AnimationPlayer.play("Hit")
	yield(get_tree().create_timer(0.3, false), "timeout")
	is_hit = false


func _on_HealthManager_health_depleted():
	is_dead = true
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.4, false), "timeout")
	call_deferred("free")
