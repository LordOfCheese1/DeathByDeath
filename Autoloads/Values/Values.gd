extends Node2D


var save_file = File.new()
var player
var is_loading_in = false


func _ready():
	load_game()
	get_tree().change_scene(user_values["current_scene"])


func _process(delta):
	if is_loading_in:
		is_loading_in = false
		player.position = user_values["player_pos"]


var user_values = {
	"bow" : true,
	"grapple" : false,
	"rocket" : true,
	"player_health" : 15,
	"player_max_health" : 15,
	"player_pos" : Vector2(162, 164),
	"collected_healthups" : [],
	"defeated_bosses" : [],
	"beaten_game" : false,
	"current_scene" : "res://Scenes/Level-0_Start.tscn"
}


func save_game():
	save_file.open("user://savefile.json", File.WRITE)
	save_file.store_string(to_json(user_values))
	save_file.close()


func load_game():
	is_loading_in = true
	save_file.open("user://savefile.json", File.READ)
	if parse_json(save_file.get_as_text()) != null:
		user_values = parse_json(save_file.get_as_text())
	save_file.close()


func delete_file():
	save_file.open("user://savefile.json", File.WRITE)
	save_file.store_string(to_json(null))
