extends KinematicBody2D


var spotted_player = false
var velocity = Vector2()
var gravity = 400


func _ready():
	pass


func _physics_process(delta):
	
	move_and_slide(velocity)
	velocity.y += gravity * delta
	
	if EnemyFunctions.distance(Values.player.position, position).x < 128 && EnemyFunctions.distance(Values.player.position, position).y < 128 && !spotted_player:
		spotted_player = true
	
	if spotted_player:
		if velocity.y > 60 && EnemyFunctions.distance(Values.player.position, position).y < 128:
			flap()
			velocity.x += (Values.player.position.x - position.x) / 6
			$Visuals.rotation_degrees = velocity.x / 4
			
			if Values.player.position.x - position.x > 0:
				$Visuals.scale.x = 1
			else:
				$Visuals.scale.x = -1


func flap():
	$AnimationPlayer.play("Flap")
	velocity.y = -100
