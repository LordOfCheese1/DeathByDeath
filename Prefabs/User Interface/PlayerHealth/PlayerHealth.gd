extends Node2D


func _ready():
	$TextManager.change_text("HP_" + str(Values.user_values["player_health"]), 0)


func update():
	$TextManager.change_text("HP_" + str(Values.user_values["player_health"]), 0)
	$AnimationPlayer.play("Update")
