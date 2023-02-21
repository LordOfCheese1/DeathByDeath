extends Node2D


var is_dead = false
var blood = load("res://Prefabs/Projectiles/Blood/Blood.tscn")
var spotted_player = false
var velocity = Vector2()
var regular_moving = false
var is_attacking = false
var dash = Vector2()


func _ready():
	$Visuals/Scythe/Attackbox.add_to_group("enemy")
	$Visuals/Scythe/Hitbox.add_to_group("enemy")
	$Visuals/Scythe/ParticleSpawner.spawn_at = get_parent()


func _physics_process(delta):
	if EnemyFunctions.distance(Values.player.position, position).x < 120 && EnemyFunctions.distance(Values.player.position, position).y < 80 && spotted_player == false:
		MusicManager._switch_track("res://Audio/Music/2KyrieEleison.mp3")
		$AnimationPlayer.play("Awaken")
		yield(get_tree().create_timer(1.2, false), "timeout")
		$Visuals/Scythe/ParticleSpawner._start()
		regular_moving = true
		spotted_player = true
		yield(get_tree().create_timer(5, false), "timeout")
		attack_combo()
	
	if spotted_player:
		$Visuals.look_at(Values.player.position)
		if regular_moving:
			if randi() % 24 == 0 && $HealthManager.health < 22:
				var blood_inst = blood.instance()
				blood_inst.position = $Visuals/Scythe/BloodSpawner.global_position
				get_parent().add_child(blood_inst)
			position.x += ((Values.player.position.x - 20) - position.x) / 64
			position.y += ((Values.player.position.y - 64) - position.y) / 64
		position += dash


func attack_combo():
	if !is_dead:
		is_attacking = true
		regular_moving = false
		dash.y = ((Values.player.position.y - 80) - position.y) / 80
		$AnimationPlayer.play("Attack1")
		yield(get_tree().create_timer(0.7, false), "timeout")
		dash.y = ((Values.player.position.y - 50) - position.y) / 64
		yield(get_tree().create_timer(1.81, false), "timeout")
		is_attacking = false
		regular_moving = true
		dash = Vector2(0, 0)
		yield(get_tree().create_timer(3, false), "timeout")
		attack_combo()


func _on_Hitbox_on_hit():
	if !is_attacking && regular_moving && !is_dead:
		$AnimationPlayer.play("Hit")


func _on_HealthManager_health_depleted():
	MusicManager._switch_track("res://Audio/Music/GosienneNo1.mp3")
	is_dead = true
	regular_moving = false
	is_attacking = false
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(1.1, false), "timeout")
	call_deferred("free")
