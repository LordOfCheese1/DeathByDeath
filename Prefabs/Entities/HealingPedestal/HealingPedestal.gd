extends StaticBody2D


func _ready():
	pass


func _on_Hitbox_on_hit():
	$HealthManager.health += 2
	$AnimationPlayer.play("Heal")
	yield(get_tree().create_timer(1, false), "timeout")
	Values.player.heal(Values.user_values["player_max_health"] - Values.user_values["player_health"])
	Values.save_game()
