extends Area2D


var pickup_screen = load("res://Prefabs/User Interface/PowerupScreen/PowerupScreen.tscn")
export var canvaslayer : NodePath


func _ready():
	yield(get_tree().create_timer(0.1, false), "timeout")
	if Values.user_values["bow"] == true:
		call_deferred("free")


func _on_BowPickup_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("Collect")
		Values.user_values["bow"] = true
		Values.save_game()
		yield(get_tree().create_timer(0.6, false), "timeout")
		var pickup_screen_inst = pickup_screen.instance()
		pickup_screen_inst.input = "RMB"
		pickup_screen_inst.action = "SHOOT_YOUR_SWORD"
		pickup_screen_inst.usage = load("res://Textures/Interface/BowDepiction.png")
		get_node(canvaslayer).add_child(pickup_screen_inst)
		call_deferred("free")
