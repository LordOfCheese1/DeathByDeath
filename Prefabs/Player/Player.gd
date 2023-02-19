extends KinematicBody2D


var is_hit = false
var gravity = 350
var jump_velocity = -115
var accel = 5
var speed = 60
var velocity = Vector2()
var coyote_time = 0
var remember_jump = 0
var is_plummiting = false
var is_jumping = false
var is_bouncing = false
var max_coyote_time = 8
var is_attacking = false


func _ready():
	Values.player = self
	add_to_group("player")


func _physics_process(delta):
	velocity.x = stepify(velocity.x, speed / accel)
	
	#velocity stuff
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	#doing stuff with vertical velocity
	if velocity.y < 350:
		velocity.y += gravity * delta
	
	if is_on_floor():
		if is_jumping:
			is_jumping = false
		
		coyote_time = max_coyote_time
	else:
		if coyote_time > 0:
			coyote_time -= 1
	
	if coyote_time > 0:
		if remember_jump > 0 && !is_bouncing:
			jump()
	
	if remember_jump > 0:
		remember_jump -= 1
	
	#jump
	if Input.is_action_just_pressed("jump"):
		remember_jump = 4
	
	#doing stuff with horizontal velocity
	if Input.is_action_pressed("ui_left"):
		if velocity.x > -speed:
			velocity.x -= speed / accel
	elif Input.is_action_pressed("ui_right"):
		if velocity.x < speed:
			velocity.x += speed / accel
	elif is_on_floor(): #lower velocity if not moving
		if velocity.x > 0:
			velocity.x -= speed / accel
		elif velocity.x < 0:
			velocity.x += speed / accel
	
	
	#all the attacks/abilities
	if Input.is_action_just_pressed("attack") && !is_attacking:
		attack()


func _process(delta):
	#Animations
	$Visuals.rotation_degrees = velocity.x / 4
	
	if velocity.x != 0:
		if !is_jumping && is_on_floor() && !is_attacking && !is_hit:
			$AnimationPlayer.play("walk")
	else:
		if is_on_floor() && !is_jumping && !is_attacking && !is_hit:
			$AnimationPlayer.play("idle")
	
	if velocity.x > 0:
		$Visuals.scale.x = -1
	elif velocity.x < 0:
		$Visuals.scale.x = 1


func jump():
	if !is_attacking && !is_hit:
		$AnimationPlayer.play("jump")
	is_jumping = true
	position.y -= 1
	velocity.y = jump_velocity
	coyote_time = 0


func attack():
	if !is_hit:
		$AnimationPlayer.play("Attack")
	is_attacking = true
	yield(get_tree().create_timer(0.2, false), "timeout")
	is_attacking = false


func _on_Hitbox_on_hit():
	randomize()
	is_hit = true
	$AnimationPlayer.play("Hit")
	var multiplier = [1,-1]
	velocity.x = speed * multiplier[randi() % multiplier.size()]
	velocity.y = jump_velocity / 2
	Values.player_health = $HealthManager.health
	$HealthManager.health = Values.player_health
	$HealthManager.max_health = Values.player_max_health
	Engine.time_scale = 0.1
	MusicManager.volume_db = -18
	while Engine.time_scale < 1:
		MusicManager.volume_db += 2
		Engine.time_scale += 0.1
		yield(get_tree().create_timer(0.05, true), "timeout")
	is_hit = false

func heal(amount):
	$HealthManager.health += amount
	$HealthManager.health = Values.player_health
