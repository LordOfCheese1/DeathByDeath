extends KinematicBody2D


var player
var velocity = Vector2()
var gravity = 350
var jump_velocity = -50
var dodge_velocity = 120


func _ready():
	$Visuals/Body/ParticleSpawner.spawn_at = get_parent()


func _physics_process(delta):
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.y < 350:
		velocity.y += gravity * delta
	
	if player == null && Values.player != null:
		player = Values.player
	
	if player != null && get_node_or_null("Visuals/Body/Connector") != null:
		$Visuals/Body/Connector.look_at(player.position)
		$Visuals/Body/Connector.rotation_degrees = $Visuals/Body/Connector.rotation_degrees - 40
		
		if player.position.x - position.x > 16:
			$Visuals.scale.x = 1
		elif player.position.x - position.x < -16:
			$Visuals.scale.x = -1
		$Visuals/Body/Connector/Hand.rotation_degrees = -$Visuals/Body/Connector.rotation_degrees / 1.5
	elif get_node_or_null("Visuals/Body/Connector") == null:
		
		if player.position.x > position.x:
			$Visuals.scale.x = 1
		else:
			$Visuals.scale.x = -1
	
	if EnemyFunctions.distance(player.position, position).x < 50:
		if is_on_floor():
			velocity.y = jump_velocity
			if get_node_or_null("Visuals/Body/Connector") == null:
				$AnimationPlayer.play("Jump")
				if player.position > position:
					velocity.x = dodge_velocity
				else:
					velocity.x = -dodge_velocity
			else:
				if player.position > position:
					velocity.x = -dodge_velocity
				else:
					velocity.x = dodge_velocity
	
	if is_on_floor():
		if velocity.x > 0:
			velocity.x -= dodge_velocity / 5
		elif velocity.x < 0:
			velocity.x += dodge_velocity / 5


func _on_Shield_shield_down():
	$AnimationPlayer.play("HandDecay")
	yield(get_tree().create_timer(0.7, false), "timeout")
	jump_velocity = -120
	dodge_velocity = 80
	$Visuals/Body/Connector.call_deferred("free")


func _on_Hitbox_on_hit():
	velocity.y = -60
	if player.position.x > position.x:
		velocity.x = -dodge_velocity / 2
	elif player.position.x < position.x:
		velocity.x = dodge_velocity / 2
	$AnimationPlayer.play("Hit")


func _on_HealthManager_health_depleted():
	$Attackbox.call_deferred("free")
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.5, false), "timeout")
	call_deferred("free")
