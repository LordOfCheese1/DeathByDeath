extends KinematicBody2D


var velocity = Vector2()
var gravity = 300
var flap_velocity = -120
var spotted_player = false
var is_dead = false
var required_player_distance = 96
var attack_cooldown = 0
var time_elapsed = 0
var spiderbird_egg = load("res://Prefabs/Projectiles/SpiderBirdEgg/SpiderBirdEgg.tscn")


func _ready():
	$Hitbox.add_to_group("enemy")
	$Attackbox.add_to_group("enemy")
	yield(get_tree().create_timer(0.1, false), "timeout")
	if Values.user_values["defeated_bosses"].has(name):
		call_deferred("free")


func _physics_process(delta):
	if EnemyFunctions.distance(Values.player.position, position).x < 128 && EnemyFunctions.distance(Values.player.position, position).y < 128 && !spotted_player:
		spotted_player = true
		MusicManager._switch_track("res://Audio/Music/DomineJesu.mp3")
	
	move_and_slide(velocity)
	velocity.y += gravity * delta
	$Visuals.rotation_degrees = velocity.x / 4
	
	if Values.player.position.x > position.x:
		$Visuals.scale.x = -1
	else:
		$Visuals.scale.x = 1
	
	if spotted_player:
		if velocity.y > 80 && EnemyFunctions.distance(Values.player.position, position).y < required_player_distance:
			if !is_dead:
				flap()
		if !is_dead:
			velocity.x += (Values.player.position.x - position.x) * delta
	
	
	if attack_cooldown > 0:
		attack_cooldown -= 1
	else:
		required_player_distance = 96
	
	
	if spotted_player:
		time_elapsed += 1
		if time_elapsed > (480 - ($HealthManager.max_health - $HealthManager.health) * 2):
			time_elapsed = 0
			attack()
	
	velocity.x = clamp(velocity.x, -120, 120)


func flap():
	velocity.y = flap_velocity
	if !is_dead:
		$AnimationPlayer.play("Flap")


func attack():
	if !is_dead:
		var spiderbird_egg_inst = spiderbird_egg.instance()
		spiderbird_egg_inst.position = position
		get_parent().add_child(spiderbird_egg_inst)
		$AnimationPlayer.play("Dive")
	velocity.y = -80
	required_player_distance = 24
	attack_cooldown = 140


func _on_Hitbox_on_hit():
	if attack_cooldown <= 0:
		$AnimationPlayer.play("Hit")
	if !spotted_player:
		spotted_player = true
		MusicManager._switch_track("res://Audio/Music/DomineJesu.mp3")


func _on_HealthManager_health_depleted():
	Values.user_values["defeated_bosses"].append(name)
	is_dead = true
	MusicManager._switch_track("res://Audio/Music/Introitus.mp3")
	velocity = Vector2(0, 0)
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.3, false), "timeout")
	call_deferred("free")
