extends Area2D


var speed = 140
var is_dead = false


func _ready():
	add_to_group("enemy")
	$Attackbox.add_to_group("enemy")


func _physics_process(delta):
	position += transform.x * delta * speed
	
	if is_dead:
		modulate.a -= 0.02
		if modulate.a <= 0:
			call_deferred("free")


func _on_FishSpike_body_entered(body):
	if body.get_class() == "TileMap":
		destroy()


func destroy():
	$Attackbox/CollisionShape2D.call_deferred("free")
	speed = 0
	is_dead = true
