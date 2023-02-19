extends Area2D


var dead = false
var y_velocity = 50


func _ready():
	$Attackbox.add_to_group("enemy")


func _physics_process(delta):
	position.y += y_velocity * delta
	y_velocity += 3


func _on_Blood_body_entered(body):
	y_velocity = 0
	$Attackbox/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Disappear")
	yield(get_tree().create_timer(0.2, false), "timeout")
	call_deferred("free")
