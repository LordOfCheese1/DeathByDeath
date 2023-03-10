extends Node2D


var save_file = File.new()
var player
var is_loading_in = false
var player_look_dir = 0
var lowe_specs = false


func _ready():
	pass#load_game()


var user_values = {
	"load_on_start" : false,
	"bow" : false,
	"rocket" : false,
	"player_health" : 15,
	"player_max_health" : 15,
	"player_x" : 162,
	"player_y" : 164,
	"collected_healthups" : [],
	"defeated_bosses" : [],
	"beaten_game" : false,
	"current_scene" : "res://Scenes/Cutscenes/Intro/Intro.tscn",
	"current_music" : "res://Audio/Music/GosienneNo1.mp3"
}


func _process(delta):
	if is_loading_in:
		is_loading_in = false
		if player != null:
			player.position.x = user_values["player_x"]
			player.position.y = user_values["player_y"]


func save_game():
	user_values["player_x"] = round(player.position.x)
	user_values["player_y"] = round(player.position.y)
	save_file.open("user://savefile.json", File.WRITE)
	save_file.store_string(to_json(user_values))
	save_file.close()


func load_game():
	save_file.open("user://savefile.json", File.READ)
	if parse_json(save_file.get_as_text()) != null:
		user_values = parse_json(save_file.get_as_text())
	save_file.close()
	if user_values["load_on_start"] == true:
		get_tree().change_scene(user_values["current_scene"])
		is_loading_in = true
		MusicManager._switch_track(user_values["current_music"])


func delete_file():
	save_file.open("user://savefile.json", File.WRITE)
	save_file.store_string(to_json(null))
