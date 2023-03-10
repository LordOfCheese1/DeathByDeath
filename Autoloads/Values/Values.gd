extends Node2D


var save_file = File.new()
var player
var is_loading_in = false
var load_on_start = false
var player_look_dir = 0


func _ready():
	if load_on_start:
		load_game()
		get_tree().change_scene(user_values["current_scene"])
		is_loading_in = true


var user_values = {
	"bow" : false,
	"rocket" : false,
	"player_health" : 15,
	"player_max_health" : 15,
	"player_x" : 162,
	"player_y" : 164,
	"collected_healthups" : [],
	"defeated_bosses" : [],
	"beaten_game" : false,
	"current_scene" : "res://Scenes/MainMenu.tscn",
	"current_music" : "res://Audio/Music/GosienneNo1.mp3"
}


func _process(delta):
	if is_loading_in:
		is_loading_in = false
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


func delete_file():
	save_file.open("user://savefile.json", File.WRITE)
	save_file.store_string(to_json(null))
