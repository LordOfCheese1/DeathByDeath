extends KinematicBody2D


var velocity = Vector2()
var spotted_player = false
var speed = 70
var is_hit = false
var is_dead = false


func _ready():
	pass


func _physics_process(delta):
	move_and_slide(velocity)
	
	if !spotted_player && EnemyFunctions.distance(Values.player.position, position).x < 128 && EnemyFunctions.distance(Values.player.position, position).y < 128:
		spotted_player = true
	
	
	if spotted_player && !is_dead:
		if !is_hit:
			$AnimationPlayer.play("Swim")
		if Values.player.position.x > position.x:
			velocity.x += speed / 20
			$Visuals.scale.x = 1
		else:
			velocity.x -= speed / 20
			$Visuals.scale.x = -1
		if Values.player.position.y > position.y:
			velocity.y += speed / 20
		else:
			velocity.y -= speed / 20
	else:
		velocity = Vector2(0, 0)
	
	
	velocity.x = clamp(velocity.x, -speed, speed)
	velocity.y = clamp(velocity.y, -speed, speed)


func _on_Hitbox_on_hit():
	if !is_dead:
		is_hit = true
		if Values.player.position.x > position.x:
			velocity.x = -speed
		else:
			velocity.x = speed
		velocity.y = 0
		$AnimationPlayer.play("Hit")
		yield(get_tree().create_timer(0.4, false), "timeout")
		is_hit = false


func _on_HealthManager_health_depleted():
	is_dead = true
	$Attackbox.call_deferred("free")
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.4, false), "timeout")
	call_deferred("free")
