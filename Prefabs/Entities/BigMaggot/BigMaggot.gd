extends KinematicBody2D


var spotted_player = false
var velocity = Vector2()
var gravity = 300


func _ready():
	pass


func _physics_process(delta):
	if !spotted_player && EnemyFunctions.distance(Values.player.position, position).x < 200 && EnemyFunctions.distance(Values.player.position, position).y < 128:
		spotted_player = true
