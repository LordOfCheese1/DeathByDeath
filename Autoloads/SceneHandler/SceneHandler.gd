extends Node2D


var switched_scene = false
var set_to
var current_scene = "res://Scenes/Level-0_Start.tscn"


func _ready():
	pass


func switch_scene(player_pos : Vector2, scene : String):
	yield(get_tree().create_timer(0.2), "timeout")
	current_scene = scene
	get_tree().change_scene(scene)
	switched_scene = true
	set_to = player_pos
	#yield(get_tree().create_timer(0.1), "timeout")


func _process(delta):
	if switched_scene:
		switched_scene = false
		Values.player.position = set_to
