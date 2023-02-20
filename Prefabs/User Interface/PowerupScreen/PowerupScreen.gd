extends Node2D


export var input : String
export var action : String
export var usage : Texture


func _ready():
	get_tree().paused = true
	$AnimationPlayer.play("Appear")
	$UsageDepiction.texture = usage
	yield(get_tree().create_timer(0.1, true), "timeout")
	$UserText.change_text("PRESS_" + input + "_TO_" + action + ".", 0.05)


func _on_OkayButton_pressed_ok():
	$AnimationPlayer.play_backwards("Appear")
	yield(get_tree().create_timer(0.5, true), "timeout")
	get_tree().paused = false
	call_deferred("free")
