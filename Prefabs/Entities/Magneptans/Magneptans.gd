extends Node2D


var webshooter = load("res://Prefabs/Entities/SpiderWeb/SpiderWeb.tscn")
var baby_spider = load("res://Prefabs/Entities/Pauluculmus/Pauluculmus.tscn")
var is_dead = false
var body_rot_sum = 0.0
var ceiling_pos = Vector2()
var activated = false
var distance_to_hold = 96 #64 is in reach


func _ready():
	$Visuals/Body/Hitbox.add_to_group("enemy")
	add_to_group("boss")
	ceiling_pos = global_position
	$AnimationPlayer.play("RESET")
	yield(get_tree().create_timer(0.1, false), "timeout")
	if Values.user_values["defeated_bosses"].has(name):
		call_deferred("free")


func _physics_process(delta):
	if activated:
		position.x -= ($Visuals/Body.transform.x.y * 4) * EnemyFunctions.distance(Values.player.position, position).x / 32
		position.y += ((Values.player.position.y - distance_to_hold) - position.y) / 32
	
	if !activated:
		if EnemyFunctions.distance(Values.player.position, position).y < 300:
			if EnemyFunctions.distance(Values.player.position, position).x < 32:
				MusicManager._switch_track("res://Audio/Music/DiesIrae.mp3")
				activated = true
				yield(get_tree().create_timer(2, false), "timeout")
				_shoot_stuff()


func _process(delta):
	$Visuals/Body/Eye/Pupil.look_at(Values.player.position)
	for i in $Visuals/Body.get_children():
		body_rot_sum += i.rotation_degrees
	body_rot_sum = body_rot_sum / len($Visuals/Body.get_children()) / 2
	$Visuals/Body.rotation_degrees = body_rot_sum


func _on_Hitbox_on_hit():
	randomize()
	$Hit.pitch_scale = rand_range(0.8, 1.2)
	$Hit.play(0.0)
	if !is_dead:
		$AnimationPlayer.play("Hit")


func _on_HealthManager_health_depleted():
	Values.user_values["defeated_bosses"].append(name)
	Values.save_game()
	MusicManager._switch_track("res://Audio/Music/GosienneNo1.mp3")
	is_dead = true
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.9, false), "timeout")
	call_deferred("free")


func _shoot_stuff():
	distance_to_hold = 124
	for i in range(2 + (ceil((46 - $HealthManager.health) / 5))):
		var baby_spider_inst = baby_spider.instance()
		baby_spider_inst.position = position
		baby_spider_inst.velocity.y = -100
		get_parent().add_child(baby_spider_inst)
		randomize()
		$Spawn.pitch_scale = rand_range(0.8, 1.2)
		$Spawn.play(0.0)
		yield(get_tree().create_timer(0.8, false), "timeout")
	for i in range(ceil((46 - $HealthManager.health) / 10)):
		randomize()
		$Spawn.pitch_scale = rand_range(0.8, 1.2)
		$Spawn.play(0.0)
		var webshooter_inst = webshooter.instance()
		webshooter_inst.position = position
		get_parent().add_child(webshooter_inst)
		yield(get_tree().create_timer(0.3, false), "timeout")
	_hitting_phase()


func _hitting_phase():
	distance_to_hold = 64
	yield(get_tree().create_timer(5.5, false), "timeout")
	_shoot_stuff()
