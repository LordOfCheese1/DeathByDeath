extends Area2D


func _ready():
	yield(get_tree().create_timer(0.1, false), "timeout")
	if Values.user_values["collected_healthups"].has(name):
		call_deferred("free")


func _on_MaxHealthPickup_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("Collect")
		yield(get_tree().create_timer(0.5, false), "timeout")
		Values.user_values["player_max_health"] += 5
		Values.player.heal(Values.user_values["player_max_health"] - Values.user_values["player_health"])
		Values.user_values["collected_healthups"].append(name)
		call_deferred("free")
