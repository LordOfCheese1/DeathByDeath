extends Area2D


export var player_pos : Vector2
export var scene : String
export var switch_track_to : String


func _ready():
	pass


func _on_TransitionManager_body_entered(body):
	if body.is_in_group("player"):
		if switch_track_to != "":
			MusicManager._switch_track(switch_track_to)
		SceneHandler.switch_scene(player_pos, scene)
