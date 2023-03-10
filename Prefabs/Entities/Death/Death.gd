extends KinematicBody2D


var velocity = Vector2()
var phase = 0
var gravity = 250
var spotted_player = false
var wall_nearby = false
var bullet = load("res://Prefabs/Projectiles/DeathBullet/DeathBullet.tscn")
var scythe = load("res://Prefabs/Projectiles/ScytheProjectile/ScytheProjectile.tscn")
var shooting_cooldown = 200
var shoot_pattern = 0
var initial_pos = Vector2()


func _ready():
	initial_pos.x = stepify(position.x, 160)
	initial_pos.y = stepify(position.y, 104)
	add_to_group("enemy")
	$Hitbox.add_to_group("enemy")


func _physics_process(delta):
	if $Visuals/Body.rotation_degrees > 0:
		$Visuals/Body.rotation_degrees -= 2
	elif $Visuals/Body.rotation_degrees < 0:
		$Visuals/Body.rotation_degrees += 2
	$LookAtPlayer.look_at(Values.player.position)
	
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.x == 0:
		wall_nearby = false
	
	$Visuals/Body/Hat.rotation_degrees = -velocity.x / 6
	$Visuals/Body/Coat.rotation_degrees = velocity.x / 12
	if Values.player.position.x > position.x:
		$Visuals/Body.flip_h = true
	else:
		$Visuals/Body.flip_h = false
	
	if spotted_player:
		
		if phase == 0: #Phase 1 stuff
			if velocity.y < gravity:
				velocity.y += gravity * delta
			if EnemyFunctions.distance(Values.player.position, position).x < 140 && !wall_nearby:
				if Values.player.position.x - position.x > 0:
					velocity.x -= 5
				else:
					velocity.x += 5
			elif EnemyFunctions.distance(Values.player.position, position).x > 160:
				if Values.player.position.x - position.x > 0:
					velocity.x += 5
				else:
					velocity.x -= 5
			else:
				if velocity.x > 0:
					velocity.x -= 5
				elif velocity.x < 0:
					velocity.x += 5
			
			if  shooting_cooldown > 0:
				shooting_cooldown -= 1
			else:
				shooting_cooldown = 100
				if shoot_pattern == 0:
					shoot_pattern = 1
					for i in 3:
						shoot_3_times()
						yield(get_tree().create_timer(0.1, false), "timeout")
				elif shoot_pattern == 1:
					shoot_circle()
					shoot_pattern = 2
				else:
					shoot_pattern = 0
					for i in 8:
						shoot_at_player()
						yield(get_tree().create_timer(0.05, false), "timeout")
		elif phase == 1:
			$CollisionShape2D.disabled = true
			velocity.y = (Values.player.position.y - (60 + shooting_cooldown / 3)) - position.y
			if Values.player.position.x > position.x:
				if velocity.x < 70:
					velocity.x += 5
			else:
				if velocity.x > -70:
					velocity.x -= 5
			
			if  shooting_cooldown > 0:
				shooting_cooldown -= 1
			else:
				shooting_cooldown = 200
				if shoot_pattern == 0:
					shoot_pattern = 1
					for i in 3:
						shoot_snake()
						yield(get_tree().create_timer(0.15, false), "timeout")
				elif shoot_pattern == 1:
					shoot_pattern = 2
					for i in 2:
						shoot_duo()
						yield(get_tree().create_timer(0.6, false), "timeout")
				else:
					shoot_pattern = 0
					for i in 8:
						shoot_circle_twisted()
						yield(get_tree().create_timer(0.2, false), "timeout")
		elif phase == 2:
			velocity.y = (initial_pos.y - (shooting_cooldown / 3)) - position.y
			velocity.x = stepify(Values.player.position.x - position.x, 5)
			
			if  shooting_cooldown > 0:
				shooting_cooldown -= 1
			else:
				shooting_cooldown = 250
				if shoot_pattern == 0:
					shoot_pattern = 1
					shoot_scythe_ray()
				elif shoot_pattern == 1:
					shoot_pattern = 2
					for i in 5:
						shoot_half_circle()
						yield(get_tree().create_timer(0.1, false), "timeout")
				elif shoot_pattern == 2:
					shoot_pattern = 0
					var adder = 0
					for i in range(20):
						shoot_star(adder)
						adder += 14
						yield(get_tree().create_timer(0.1, false), "timeout")
			
	else: #spot player
		if EnemyFunctions.distance(Values.player.position, position).x < 128 && EnemyFunctions.distance(Values.player.position, position).y < 90:
			spotted_player = true
			MusicManager._switch_track("res://Audio/Music/Kyrie.mp3")


func _on_WallDetector_body_entered(body):
	if body.get_class() == "TileMap":
		wall_nearby = true


func _on_WallDetector_body_exited(body):
	if body.get_class() == "TileMap":
		wall_nearby = false


func _on_Hitbox_on_hit():
	$Visuals/Body.rotation_degrees = 20
	randomize()
	$Hit.pitch_scale = rand_range(0.8, 1.2)
	$Hit.play(0.0)
	if $HealthManager.health < 100 && phase < 1:
		shoot_pattern = 0
		phase = 1
		shooting_cooldown = 200
	if $HealthManager.health < 50 && phase < 2:
		shoot_pattern = 0
		phase = 2
	if $HealthManager.health <= 0 && phase < 3:
		death()


func shoot_3_times():
	for i in [-1, 0, 1]:
		var bullet_inst = bullet.instance()
		bullet_inst.position = global_position
		bullet_inst.rotation_degrees = $LookAtPlayer.rotation_degrees + (i * 25)
		get_parent().add_child(bullet_inst)


func shoot_circle():
	for i in 10.25:
		var bullet_inst = bullet.instance()
		bullet_inst.position = global_position
		bullet_inst.rotation_degrees = i * 32
		get_parent().add_child(bullet_inst)


func shoot_at_player():
	var bullet_inst = bullet.instance()
	bullet_inst.position = global_position
	bullet_inst.rotation_degrees = $LookAtPlayer.rotation_degrees
	get_parent().add_child(bullet_inst)


func shoot_snake():
	for i in [-9.6, -8.4, -7.2, -6, -4.8, -3.6, -2.4, -1.2, 0, 1.2, 2.4, 3.6]:
		var bullet_inst = bullet.instance()
		bullet_inst.position = global_position
		bullet_inst.rotation_degrees = $LookAtPlayer.rotation_degrees + (i * 15)
		get_parent().add_child(bullet_inst)
		yield(get_tree().create_timer(0.05, false), "timeout")


func shoot_duo():
	for i in [-7, -6, -5, -4, -3, -2, -1, 0, 1, 7, 6, 5, 4, 3, 2, 1, 0, -1]:
		var bullet_inst = bullet.instance()
		bullet_inst.position = global_position
		bullet_inst.rotation_degrees = $LookAtPlayer.rotation_degrees + (i * 15)
		get_parent().add_child(bullet_inst)
		yield(get_tree().create_timer(0.05, false), "timeout")


func shoot_circle_twisted():
	var value = -16
	for i in 10.25:
		value += 1
		var bullet_inst = bullet.instance()
		bullet_inst.position = global_position
		bullet_inst.rotation_degrees = value * 2 + (i * 32)
		get_parent().add_child(bullet_inst)


func shoot_scythe_ray():
	for i in 8:
		var scythe_inst = scythe.instance()
		scythe_inst.position = global_position
		scythe_inst.rotation_degrees = $LookAtPlayer.rotation_degrees
		get_parent().add_child(scythe_inst)
		yield(get_tree().create_timer(0.3, false), "timeout")


func shoot_half_circle():
	for i in range(-4, 4):
		var bullet_inst = bullet.instance()
		bullet_inst.position = global_position
		bullet_inst.rotation_degrees = (i * 24) + 90
		get_parent().add_child(bullet_inst)


func shoot_star(adder : float):
	for i in [0, 90, 180, 270]:
		var bullet_inst = bullet.instance()
		bullet_inst.position = global_position
		bullet_inst.rotation_degrees = i + adder
		get_parent().add_child(bullet_inst)


func death():
	velocity = Vector2(0, 0)
	phase = 3
