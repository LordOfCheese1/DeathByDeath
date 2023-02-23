extends Node2D


var save_file = File.new()
var player
var player_health = 15
var player_max_health = 15
var collected_healthups = []
var defeated_bosses = []


func _ready():
	load_game()


var user_values = {
	"bow" : true,
	"grapple" : false,
	"rocket" : true,
	"player_health" : 0,
	"player_max_health" : 0,
	"collected_healthups" : [],
	"defeated_bosses" : [],
	"beaten_game" : false
}


func save_game():
	user_values["player_health"] = player_health
	user_values["player_max_health"] = player_max_health
	
	save_file.open("user://savefile.json", File.WRITE)
	save_file.store_string(to_json(user_values))
	save_file.close()


func load_game():
	save_file.open("user://savefile.json", File.READ)
	if parse_json(save_file.get_as_text()) != null:
		user_values = parse_json(save_file.get_as_text())
	save_file.close()
	
	defeated_bosses = user_values["defeated_bosses"]
	collected_healthups = user_values["collected_healthups"]
	player_max_health = user_values["player_max_health"]
	player_health = user_values["player_health"]


func delete_file():
	save_file.open("user://savefile.json", File.WRITE)
	save_file.store_string(to_json(null))
