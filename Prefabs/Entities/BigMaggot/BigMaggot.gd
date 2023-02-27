extends KinematicBody2D


var spotted_player = false
var velocity = Vector2()
var gravity = 300
var speed = 120
var phase = 0
var acidspit = load("res://Prefabs/Projectiles/Acidspit/Acidspit.tscn")
var shoot_cooldown = 0
var is_hit = false
var is_dead = false


func _ready():
	$Hitbox.add_to_group("enemy")
	yield(get_tree().create_timer(0.1, false), "timeout")
	if Values.user_values["defeated_bosses"].has(name):
		call_deferred("free")


func _physics_process(delta):
	$LookAt.look_at(Values.player.position)
	move_and_slide(velocity)
	if velocity.y < gravity:
		velocity.y += gravity * delta
	
	if !spotted_player && EnemyFunctions.distance(Values.player.position, position).x < 200 && EnemyFunctions.distance(Values.player.position, position).y < 128:
		spotted_player = true
		MusicManager._switch_track("res://Audio/Music/VerdiDiesIrae.mp3")
	
	if spotted_player && !is_dead:
		if !is_hit:
			$AnimationPlayer.play("Sneak")
		if Values.player.position > position:
			$Sprite.flip_h = false
			velocity.x += speed / 24
		else:
			velocity.x -= speed / 24
			$Sprite.flip_h = true
	
	velocity.x = clamp(velocity.x, -speed, speed)


func shoot():
	randomize()
	if shoot_cooldown <= 0 && !is_dead:
		if phase == 1:
			for i in [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1)]:
				var acidspit_inst = acidspit.instance()
				acidspit_inst.position.x = global_position.x
				acidspit_inst.position.y = global_position.y - 16
				acidspit_inst.direction = i
				get_parent().add_child(acidspit_inst)
		elif phase == 2:
			for i in range(4):
				var acidspit_inst = acidspit.instance()
				acidspit_inst.position.x = global_position.x
				acidspit_inst.position.y = global_position.y - 16
				acidspit_inst.direction = $LookAt.transform.x
				get_parent().add_child(acidspit_inst)
				yield(get_tree().create_timer(0.05, false), "timeout")
		shoot_cooldown = ceil($HealthManager.health / 4)
		print(str(shoot_cooldown) + " " + str($HealthManager.health))
	shoot_cooldown -= 1


func _on_Hitbox_on_hit():
	is_hit = true
	if !is_dead:
		$AnimationPlayer.play("Damage")
	if $HealthManager.health < 60 && phase < 1:
		phase = 1
	if $HealthManager.health < 30 && phase < 2:
		phase = 2
	yield(get_tree().create_timer(0.2, false), "timeout")
	is_hit = false


func _on_HealthManager_health_depleted():
	MusicManager._switch_track("res://Audio/Music/Introitus.mp3")
	Values.user_values["defeated_bosses"].append(name)
	Values.save_game()
	is_dead = true
	velocity = Vector2(0,0)
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.4, false), "timeout")
	call_deferred("free")
