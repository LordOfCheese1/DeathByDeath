extends Node2D


var in_menu = false


func _ready():
	hide()


func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		if in_menu:
			exit_menu()
		else:
			enter_menu()


func enter_menu():
	if !get_tree().paused:
		get_tree().paused = true
		show()
		in_menu = true


func exit_menu():
	get_tree().paused = false
	hide()
	in_menu = false


func _on_Continue_pressed_ok():
	if in_menu:
		exit_menu()


func _on_Title_pressed_ok():
	if in_menu:
		get_tree().paused = false
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
