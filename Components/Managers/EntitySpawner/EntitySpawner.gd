extends Node2D


export var path : String
export var required_distance : Vector2


func _ready():
	pass


func _process(delta):
	if EnemyFunctions.distance(Values.player.position, position).x < required_distance.x:
		if EnemyFunctions.distance(Values.player.position, position).y < required_distance.y:
			var inst = load(path).instance()
			inst.position = position
			get_parent().add_child(inst)
			call_deferred("free")
