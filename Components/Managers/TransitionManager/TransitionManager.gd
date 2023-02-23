extends Area2D


export var player_pos : Vector2
export var scene : String
export var switch_track_to : String
var faded_out = false


func _ready():
	pass


func _process(delta):
	if !faded_out && EnemyFunctions.distance(Values.player.position, position).x < 128:
		faded_out = true
		$AnimationPlayer.play("FadeOut")
	faded_out = true


func _on_TransitionManager_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("FadeIn")
		if switch_track_to != "":
			MusicManager._switch_track(switch_track_to)
		yield(get_tree().create_timer(0.2, false), "timeout")
		Values.user_values["current_scene"] = scene
		SceneHandler.switch_scene(player_pos, scene)
