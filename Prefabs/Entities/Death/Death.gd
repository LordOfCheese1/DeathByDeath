extends KinematicBody2D


var velocity = Vector2()
var phase = 0
var gravity = 250


func _ready():
	pass


func _physics_process(delta):
	move_and_slide(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if phase == 0:
		if velocity.y < gravity:
			velocity.y += gravity * delta
