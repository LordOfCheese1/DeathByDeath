extends Node2D


export var max_health : int
var health : int
signal health_depleted
var is_dead = false


func _ready():
	health = max_health


func _process(delta):
	if health <= 0 && !is_dead:
		is_dead = true
		emit_signal("health_depleted")
