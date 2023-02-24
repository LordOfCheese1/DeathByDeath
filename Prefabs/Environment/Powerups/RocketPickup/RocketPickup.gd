extends Area2D


var pickup_screen = load("res://Prefabs/User Interface/PowerupScreen/PowerupScreen.tscn")
export var canvaslayer : NodePath


func _ready():
	$AnimationPlayer.play("Float")
	if Values.user_values["rocket"]:
		call_deferred("free")


func _on_RocketPickup_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("Collect")
		Values.user_values["rocket"] = true
		Values.save_game()
		yield(get_tree().create_timer(0.5, false), "timeout")
		var pickup_screen_inst = pickup_screen.instance()
		pickup_screen_inst.input = "UP_WHILE_IN_THE_AIR"
		pickup_screen_inst.action = "JUMP_TWICE"
		pickup_screen_inst.usage = load("res://Textures/Interface/ExplosionDepiction.png")
		get_node(canvaslayer).add_child(pickup_screen_inst)
		call_deferred("free")
