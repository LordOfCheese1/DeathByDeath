extends Area2D


export var health_manager : NodePath
signal on_hit


func _ready():
	add_to_group("hitbox")


func hit(damage):
	emit_signal("on_hit")
	get_node(health_manager).health -= damage
