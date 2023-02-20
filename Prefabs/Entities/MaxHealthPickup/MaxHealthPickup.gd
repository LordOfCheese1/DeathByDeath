extends Area2D


func _ready():
	if Values.collected_healthups.has(name):
		call_deferred("free")


func _on_MaxHealthPickup_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("Collect")
		yield(get_tree().create_timer(0.5, false), "timeout")
		Values.player_max_health += 5
		Values.player.heal(Values.player_max_health - Values.player_health)
		Values.collected_healthups.append(name)
		call_deferred("free")
