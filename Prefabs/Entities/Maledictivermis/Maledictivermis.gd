extends KinematicBody2D


var velocity = Vector2()
var gravity = 300
var speed = 160
var spotted_player
var is_hit = false
var is_dead = false


func _ready():
	$AnimationPlayer.play("Idle")


func _physics_process(delta):
	move_and_slide(velocity)
	if velocity.y < 300:
		velocity.y += gravity * delta
	
	if !spotted_player && EnemyFunctions.distance(Values.player.position, position).x < 80 && EnemyFunctions.distance(Values.player.position, position).y < 128:
		spotted_player = true
	
	if spotted_player && !is_dead:
		if !is_hit && !is_dead:
			$AnimationPlayer.play("Crawl")
		if Values.player.position.x > position.x:
			$Sprite.flip_h = true
			velocity.x += speed / 16
		else:
			velocity.x -= speed / 16
			$Sprite.flip_h = false
	
	velocity.x = clamp(velocity.x, -speed, speed)


func _on_Hitbox_on_hit():
	if Values.player.position.x > position.x:
		velocity.x = -20
	else:
		velocity.x = 20
	is_hit = true
	$AnimationPlayer.play("Hit")
	yield(get_tree().create_timer(0.3, false), "timeout")
	is_hit = false


func _on_HealthManager_health_depleted():
	velocity.x = 0
	is_dead = true
	$AnimationPlayer.play("Death")
	yield(get_tree().create_timer(0.3, false), "timeout")
	call_deferred("free")
