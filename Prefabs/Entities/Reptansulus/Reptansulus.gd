extends KinematicBody2D


var is_dead = false
var is_hit = false
var accel = 10
var speed = 50
var jump_velocity = -130
var is_jumping = false
var gravity = 300
var velocity = Vector2()
var player
var spotted_player = false
var footstep_counter = 7


func _ready():
	$Hitbox.add_to_group("enemy")
	$Attackbox.add_to_group("enemy")
	$AnimationPlayer.play("Idle")


func _physics_process(delta):
	if player == null && Values.player != null:
		player = Values.player
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.y < 300:
		velocity.y += gravity * delta
	
	
	if !is_dead:
		if !spotted_player:
			if EnemyFunctions.distance(position, Values.player.position).x < 128 && EnemyFunctions.distance(position, Values.player.position).y < 128:
				spotted_player = true
		else: #do this if spider is in player radius
			if !is_jumping:
				if Values.player.position.x > position.x:
					walk(1)#walk left
				elif Values.player.position.x < position.x:
					walk(-1)#walk right
			
			if Values.player.position.y < position.y && Values.player.is_on_floor():
				if is_on_floor():
					jump()
		
		if is_on_floor():
			if is_jumping:
				is_jumping = false
		
		if Values.player.position.x > position.x:
			$Visuals.scale.x = 1
		elif player.position.x < position.x:
			$Visuals.scale.x = -1
	else:
		velocity.x = 0
	
	if velocity.x > 10 or velocity.x < -10 && is_on_floor() && !is_hit:
		footstep_counter -= 1
		if footstep_counter <= 0:
			$Footstep.pitch_scale = rand_range(0.8, 1.2)
			$Footstep.play(0.0)
			footstep_counter = 7


func jump():
	velocity.x = speed * $Visuals.scale.x
	if !is_hit && !is_dead:
		$AnimationPlayer.play("jump")
	is_jumping = true
	velocity.y = jump_velocity


func walk(dir : int):
	if !is_hit && !is_dead:
		$AnimationPlayer.play("Walk")
	velocity.x += (speed / accel) * dir
	velocity.x = clamp(velocity.x, -speed, speed)


func _on_Hitbox_on_hit():
	randomize()
	$Hit.pitch_scale = rand_range(0.8, 1.2)
	$Hit.play(0.0)
	is_hit = true
	if Values.player.position.x > position.x:
		velocity.x = -speed
	elif Values.player.position.x < position.x:
		velocity.x = speed
	if !is_dead:
		$AnimationPlayer.play("Hit")
	yield(get_tree().create_timer(0.2, false), "timeout")
	is_hit = false


func _on_HealthManager_health_depleted():
	$Attackbox.call_deferred("free")
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(1, false), "timeout")
	call_deferred("free")
