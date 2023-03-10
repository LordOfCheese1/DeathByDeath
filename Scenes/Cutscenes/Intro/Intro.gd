extends Node2D


func _ready():
	MusicManager._switch_track("res://Audio/Music/GosienneNo1.mp3")



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Scroll":
		get_tree().change_scene("res://Scenes/Level-0_Start.tscn")
		Values.user_values["current_scene"] = "res://Scenes/Level-0_Start.tscn"
