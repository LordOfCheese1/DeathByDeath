extends Node2D


var speed = -100
var rot_velocity = 30


func _ready():
	$Attackbox.add_to_group("enemy")


func _physics_process(delta):
	position += (transform.x * speed) * delta
	$Sprite.rotation_degrees += rot_velocity
	rot_velocity -= 0.2
	$Sprite.modulate.a -= 0.01
	speed += 10
	if $Sprite.modulate.a <= 0:
		call_deferred("free")


func _on_VisibilityEnabler2D_screen_exited():
	call_deferred("free")
