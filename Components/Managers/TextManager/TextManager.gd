extends Node2D


var letter = load("res://Components/User Interface/Letter/Letter.tscn")


func _ready():
	pass


func change_text(text: String, time : float):
	var pos = 0
	var y = 0
	for i in text:
		if i != ",":
			pos += 1
			var letter_inst = letter.instance()
			letter_inst.position.x = pos * 5
			letter_inst.position.y = y * 8
			letter_inst.texture = load("res://Textures/Interface/Letters/" + i + ".png")
			add_child(letter_inst)
		else:
			y += 1
			pos = 0
		yield(get_tree().create_timer(time, false), "timeout")
