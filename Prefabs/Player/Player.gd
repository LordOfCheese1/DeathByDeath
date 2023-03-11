extends KinematicBody2D


var health_path
export var canvaslayer : NodePath
var HealthInterface = load("res://Prefabs/User Interface/PlayerHealth/PlayerHealth.tscn")
var is_hit = false
var gravity = 350
var jump_velocity = -115
var rocket_velocity = -165
var accel = 5
var speed = 60
var velocity = Vector2()
var coyote_time = 0
var remember_jump = 0
var is_jumping = false
var max_coyote_time = 8
var is_attacking = false
var jumped = false
var double_jumped = false
var in_water = false
var footstep_counter = 16


func _ready():
	$ParticleSpawner.spawn_at = get_parent()
	$HealthManager.max_health = Values.user_values["player_max_health"]
	Values.player = self
	add_to_group("player")
	yield(get_tree().create_timer(0.1), "timeout")
	$HealthManager.health = Values.user_values["player_health"]
	
	var health_interface_inst = HealthInterface.instance()
	$CanvasLayer.add_child(health_interface_inst)
	health_path = health_interface_inst
	health_path.update()


func _physics_process(delta):
	Values.player_look_dir = -$Visuals.scale.x
	velocity.x = stepify(velocity.x, speed / accel)
	
	#velocity stuff
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	#doing stuff with vertical velocity
	if velocity.y < gravity:
		velocity.y += gravity * delta
	
	if is_on_floor():
		$ParticleSpawner._stop()
		if !in_water:
			gravity = 350
		else:
			gravity = 50
		jumped = false
		double_jumped = false
		if is_jumping:
			is_jumping = false
		
		coyote_time = max_coyote_time
	else:
		if coyote_time > 0:
			coyote_time -= 1
	
	
	if coyote_time > 0:
		if remember_jump > 0:
			jump()
			coyote_time = 0
			remember_jump = 0
			jumped = true
	elif coyote_time <= 0 && !is_on_floor() && Values.user_values["rocket"] && !double_jumped && jumped:
		if remember_jump > 0:
			$ParticleSpawner._start()
			if !in_water:
				gravity = 300
				velocity.y = rocket_velocity
			else:
				velocity.y = rocket_velocity / 2
			randomize()
			$DoubleJump.pitch_scale = rand_range(0.8, 1.2)
			$DoubleJump.play(0.0)
			double_jumped = true
	
	
	if coyote_time <= 0:
		jumped = true
	
	
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
	
	
	velocity.x = clamp(velocity.x, -speed - 12, speed + 12)
	
	
	#all the attacks/abilities
	if Input.is_action_just_pressed("attack") && !is_attacking:
		attack()
	
	if velocity.x != 0 && is_on_floor():
		footstep_counter -= 1
		if footstep_counter <= 0:
			$Footstep.pitch_scale = rand_range(0.8, 1.2)
			$Footstep.play(0.0)
			footstep_counter = 16


func _process(delta):
	$HealthManager.health = Values.user_values["player_health"]
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
	randomize()
	$Jump.pitch_scale = rand_range(0.8, 1.2)
	$Jump.play(0.0)
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
	Values.user_values["player_health"] = $HealthManager.health
	health_path.update()
	
	randomize()
	$Hit.pitch_scale = rand_range(0.9, 1.1)
	$Hit.play()
	$WhiteNoise.play()
	is_hit = true
	$AnimationPlayer.play("Hit")
	var multiplier = [1,-1]
	velocity.x = speed * multiplier[randi() % multiplier.size()]
	velocity.y = jump_velocity / 2
	Engine.time_scale = 0.1
	MusicManager.volume_db = -18
	if $HealthManager.health > 0:
		while Engine.time_scale < 1:
			MusicManager.volume_db += 2
			Engine.time_scale += 0.1
			yield(get_tree().create_timer(0.05, true), "timeout")
	else:
		MusicManager._switch_track("res://Audio/Music/MassKyrie.mp3")
		$CanvasLayer/AnimationPlayer.play("FadeIn")
		yield(get_tree().create_timer(0.2, false), "timeout")
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	is_hit = false


func heal(amount):
	$HealthManager.health += amount
	Values.user_values["player_health"] = $HealthManager.health
	health_path.update()


func _on_WaterDetector_area_entered(area):
	if area.is_in_group("water"):
		in_water = true
		jump_velocity = -60
		velocity.y = 10
		gravity = 50
		speed = 40
		velocity.x = stepify(velocity.x, 40)


func _on_WaterDetector_area_exited(area):
	if area.is_in_group("water"):
		in_water = false
		jump_velocity = -115
		gravity = 350
		speed = 60
		velocity.x = stepify(velocity.x, 12)
