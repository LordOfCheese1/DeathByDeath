extends KinematicBody2D


var velocity = Vector2()
var gravity = 300
var claw_accel = 60
var ceiling_multiplier = 1


func _ready():
	pass


func _process(delta):
	$Visuals/Body/Eye.look_at(Values.player.position)
	rotation_degrees = velocity.x / 3


func _physics_process(delta):
	claw_accel = (position.y - (Values.player.position.y - 48)) / ceiling_multiplier
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.y < gravity:
		velocity.y += gravity * delta
	
	velocity.x = clamp(velocity.x, -120, 120)
	velocity.y = clamp(velocity.y, -256, 300)


func _on_Claw2_clawed():
	if velocity.y < 0:
		velocity.y -= claw_accel
	else:
		velocity.y = -claw_accel
	
	if Values.player.position.x - position.x > 0:
		velocity.x += 20
	else:
		velocity.x -= 20
	
	if randi() % 6 == 0:
		velocity.y = -80


func _on_Claw_clawed():
	if velocity.y < 0:
		velocity.y -= claw_accel
	else:
		velocity.y = -claw_accel
	
	if Values.player.position.x - position.x > 0:
		velocity.x += 20
	else:
		velocity.x -= 20
	
	if randi() % 6 == 0:
		velocity.y = -80


func _on_CeilingDetector_body_entered(body):
	if body.get_class() == "TileMap":
		ceiling_multiplier = -2


func _on_CeilingDetector_body_exited(body):
	if body.get_class() == "TileMap":
		ceiling_multiplier = 1
