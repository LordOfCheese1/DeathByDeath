extends KinematicBody2D


var velocity = Vector2()
var spotted_player = false
var speed = 20
var is_dead = false
var spike = load("res://Prefabs/Projectiles/FishSpike/FishSpike.tscn")
var shoot_cooldown = 160


func _ready():
	yield(get_tree().create_timer(0.1, false), "timeout")
	$Hitbox.add_to_group("enemy")
	if Values.user_values["defeated_bosses"].has(name):
		call_deferred("free")


func _physics_process(delta):
	speed = 100 - ($HealthManager.health / 2)
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if EnemyFunctions.distance(Values.player.position, position).x < 120 && EnemyFunctions.distance(Values.player.position, position).y < 64 && !spotted_player:
		spotted_player = true
		MusicManager._switch_track("res://Audio/Music/HungarianDance5.mp3")
	
	look_at(Values.player.position)
	if spotted_player && !is_dead:
		velocity += (transform.x * 80) / ($HealthManager.health + 20)
		shoot_cooldown -= 1
		if shoot_cooldown <= 0:
			shoot_cooldown = 140 - (80 - $HealthManager.health)
			shoot_circle()
	else:
		velocity = Vector2(0, 0)
	if is_on_floor():
		velocity.y = -20
	if is_on_ceiling():
		velocity.y = 20
	if is_on_wall():
		if velocity.x > 0:
			velocity.x = 20
		else:
			velocity.x = -20
	
	scale.x = (200 - (EnemyFunctions.distance(Values.player.position, position).x + EnemyFunctions.distance(Values.player.position, position).y) / 2) / 200
	scale.x = clamp(scale.x, 0.1, 2)
	scale.y = scale.x
	
	velocity.x = clamp(velocity.x, -speed, speed)
	velocity.y = clamp(velocity.y, -speed, speed)


func shoot_at_player():
	var spike_inst = spike.instance()
	spike_inst.position = global_position
	spike_inst.rotation_degrees = rotation_degrees
	get_parent().add_child(spike_inst)


func shoot_circle():
	var value = -16
	for i in 10.25:
		value += 1
		var spike_inst = spike.instance()
		spike_inst.position = global_position
		spike_inst.rotation_degrees = (value * 2 + (i * 32)) + rotation_degrees
		get_parent().add_child(spike_inst)


func _on_Hitbox_on_hit():
	if !spotted_player:
		spotted_player = true
		MusicManager._switch_track("res://Audio/Music/HungarianDance5.mp3")
	if !is_dead:
		$AnimationPlayer.play("Hit")
	velocity = transform.x * -15


func _on_HealthManager_health_depleted():
	is_dead = true
	MusicManager._switch_track("res://Audio/Music/LaFollia.mp3")
	Values.user_values["defeated_bosses"].append(name)
	Values.save_game()
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.6, false), "timeout")
	call_deferred("free")
