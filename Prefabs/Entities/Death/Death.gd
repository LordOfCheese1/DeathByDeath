extends KinematicBody2D


var velocity = Vector2()
var phase = 0
var gravity = 250
var spotted_player = false
var wall_nearby = false
var bullet = load("res://Prefabs/Projectiles/DeathBullet/DeathBullet.tscn")
var shooting_cooldown = 20
var shoot_pattern = 0


func _ready():
	add_to_group("enemy")
	$Hitbox.add_to_group("enemy")


func _physics_process(delta):
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
			
	else: #spot player
		if EnemyFunctions.distance(Values.player.position, position).x < 128:
			spotted_player = true
			MusicManager._switch_track("res://Audio/Music/Confutatis.mp3")


func _on_WallDetector_body_entered(body):
	if body.get_class() == "TileMap":
		wall_nearby = true


func _on_WallDetector_body_exited(body):
	if body.get_class() == "TileMap":
		wall_nearby = false


func _on_Hitbox_on_hit():
	randomize()
	$Hit.pitch_scale = rand_range(0.8, 1.2)
	$Hit.play(0.0)


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
