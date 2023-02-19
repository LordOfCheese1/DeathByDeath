extends Node2D


export var current_swing = 0
export var should_turn = true
var can_attack = true
export var emit_particles = true


func _ready():
	$Pivot/AnimPivot/Graphics/ParticleSpawner.spawn_at = get_parent().get_parent()


func _physics_process(delta):
	if should_turn:
		$Pivot.look_at(get_global_mouse_position())
	
	if $Pivot.rotation_degrees >= 360 or $Pivot.rotation_degrees <= -360:
		rotation_degrees = 0
	$Pivot/AnimPivot/Graphics/ParticleSpawner/Timer.paused = emit_particles


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		swing_attack()


func swing_attack():
	$Pivot.look_at(get_global_mouse_position())
	$AnimationPlayer.play("Swing" + str(current_swing))
