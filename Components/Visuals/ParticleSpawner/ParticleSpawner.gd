extends Node2D


export var place_on_z : int
export var pause_on_start : bool
export var wait_time : float
var spawn_at
export var particle_to_spawn : String


func _ready():
	$Timer.wait_time = wait_time
	$Timer.start()
	if pause_on_start:
		$Timer.paused = true


func _start():
	$Timer.paused = false


func _stop():
	$Timer.paused = true


func _on_Timer_timeout():
	var particle_inst = load(particle_to_spawn).instance()
	particle_inst.position = global_position
	particle_inst.z_index = place_on_z
	spawn_at.add_child(particle_inst)
