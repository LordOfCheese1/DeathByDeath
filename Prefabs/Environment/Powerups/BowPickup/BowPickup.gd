extends Area2D


var pickup_screen = load("res://Prefabs/User Interface/PowerupScreen/PowerupScreen.tscn")
export var canvaslayer : NodePath


func _ready():
	pass


func _on_BowPickup_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("Collect")
		yield(get_tree().create_timer(0.6, false), "timeout")
		var pickup_screen_inst = pickup_screen.instance()
		get_node(canvaslayer).add_child(pickup_screen_inst)
		Values.bow = true
		call_deferred("free")
