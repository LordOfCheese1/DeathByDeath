extends KinematicBody2D


var velocity = Vector2()
var phase = 0
var gravity = 250
var spotted_player = false
var wall_nearby = false


func _ready():
	pass


func _physics_process(delta):
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.x == 0:
		wall_nearby = false
	
	$Visuals/Body/Hat.rotation_degrees = -velocity.x / 6
	$Visuals/Body/Coat.rotation_degrees = velocity.x / 12
	if Values.player.position.x > position.x:
		$Visuals/Body.flip_h = true
	else:
		$Visuals/Body.flip_h = false
	
	if spotted_player:
		if phase == 0:
			if velocity.y < gravity:
				velocity.y += gravity * delta
			if EnemyFunctions.distance(Values.player.position, position).x < 96 && !wall_nearby:
				if Values.player.position.x - position.x > 0:
					velocity.x -= 5
				else:
					velocity.x += 5
			elif EnemyFunctions.distance(Values.player.position, position).x > 140 && !wall_nearby:
				if Values.player.position.x - position.x > 0:
					velocity.x += 5
				else:
					velocity.x -= 5
			else:
				if velocity.x > 0:
					velocity.x -= 5
				elif velocity.x < 0:
					velocity.x += 5
	else:
		if EnemyFunctions.distance(Values.player.position, position).x < 128:
			spotted_player = true
			MusicManager._switch_track("res://Audio/Music/MozartSymphony40.mp3")


func _on_WallDetector_body_entered(body):
	if body.get_class() == "TileMap":
		wall_nearby = true


func _on_WallDetector_body_exited(body):
	if body.get_class() == "TileMap":
		wall_nearby = false
