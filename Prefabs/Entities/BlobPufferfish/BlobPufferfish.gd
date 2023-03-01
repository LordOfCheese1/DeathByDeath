extends KinematicBody2D


var velocity = Vector2()
var spotted_player = false
var speed = 20


func _ready():
	pass


func _physics_process(delta):
	speed = 100 - ($HealthManager.health / 2)
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if EnemyFunctions.distance(Values.player.position, position).x < 120 && EnemyFunctions.distance(Values.player.position, position).y < 64 && !spotted_player:
		spotted_player = true
		MusicManager._switch_track("res://Audio/Music/HungarianDance5.mp3")
	
	look_at(Values.player.position)
	if spotted_player:
		velocity += (transform.x * 80) / ($HealthManager.health + 20)
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


func _on_Hitbox_on_hit():
	$AnimationPlayer.play("Hit")
	velocity = transform.x * -15


func _on_HealthManager_health_depleted():
	MusicManager._switch_track("res://Audio/Music/Humoresque.mp3")
	call_deferred("free")
