extends KinematicBody2D


var egg = load("res://Prefabs/Projectiles/Egg/Egg.tscn")
var spotted_player = false
var velocity = Vector2()
var gravity = 400
var is_dead = false
var egg_cooldown = 100


func _ready():
	add_to_group("enemy")
	$Hitbox.add_to_group("enemy")


func _physics_process(delta):
	move_and_slide(velocity)
	if velocity.y < 350:
		velocity.y += gravity * delta
	
	if EnemyFunctions.distance(Values.player.position, position).x < 128 && EnemyFunctions.distance(Values.player.position, position).y < 128 && !spotted_player:
		spotted_player = true
	
	if spotted_player:
		if velocity.y > 60 && EnemyFunctions.distance(Values.player.position, position).y < 128:
			if !is_dead:
				flap()
		velocity.x += (Values.player.position.x - position.x) * delta
		
		if EnemyFunctions.distance(Values.player.position, position).x < 64 && EnemyFunctions.distance(Values.player.position, position).y > 64:
			if egg_cooldown > 0:
				egg_cooldown -= 1
			else:
				egg_cooldown = 100
				var egg_inst = egg.instance()
				egg_inst.position = position
				get_parent().add_child(egg_inst)
		
	
	if Values.player.position.x - position.x > 0:
		$Visuals.scale.x = 1
	else:
		$Visuals.scale.x = -1
	
	$Visuals.rotation_degrees = velocity.x / 4
	velocity.x = clamp(velocity.x, -100, 100)


func flap():
	$Flap.pitch_scale = rand_range(0.8, 1.2)
	$Flap.play(0.0)
	$AnimationPlayer.play("Flap")
	velocity.y = -100


func _on_Hitbox_on_hit():
	velocity.y = -120
	if Values.player.position.x > position.x:
		velocity.x = -20
	else:
		velocity.x = 20


func _on_HealthManager_health_depleted():
	is_dead = true
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.4, false), "timeout")
	call_deferred("free")
