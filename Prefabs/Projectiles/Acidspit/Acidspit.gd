extends Area2D


var direction = Vector2()
var speed = 110


func _ready():
	$Attackbox.add_to_group("enemy")


func _physics_process(delta):
	$Sprite.rotation_degrees += 1.5
	position += (direction * speed) * delta


func _on_Acidspit_body_entered(body):
	$AnimationPlayer.play("Pop")
	yield(get_tree().create_timer(0.1, false), "timeout")
	call_deferred("free")


func _on_Attackbox_on_attack():
	$AnimationPlayer.play("Pop")
	yield(get_tree().create_timer(0.2, false), "timeout")
	call_deferred("free")
