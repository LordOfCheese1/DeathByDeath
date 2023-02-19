extends Area2D


export var player_pos : Vector2
export var scene : String


func _ready():
	pass


func _on_TransitionManager_body_entered(body):
	if body.is_in_group("player"):
		SceneHandler.switch_scene(player_pos, scene)
