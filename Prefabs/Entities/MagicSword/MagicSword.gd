extends Node2D


export var current_swing = 0
export var should_turn = true
var can_attack = true
export var emit_particles = true
var shoot_cooldown = false

var sword_projectile = load("res://Prefabs/Projectiles/SwordProjectile/SwordProjectile.tscn")


func _ready():
	if Values.lowe_specs:
		$Pivot/AnimPivot/Graphics/ParticleSpawner.wait_time = 0.05
		$Pivot/AnimPivot/Graphics/ParticleSpawner/Timer.wait_time = $Pivot/AnimPivot/Graphics/ParticleSpawner.wait_time
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
	if Values.user_values["bow"] == true:
		if Input.is_action_just_pressed("shoot") && !shoot_cooldown:
			if get_parent().is_in_group("player"):
				get_parent().velocity.y += -$Pivot.transform.x.y * 50
				get_parent().velocity.x += stepify(-$Pivot.transform.x.x * 80, 12)
			shoot_cooldown = true
			var sword_projectile_inst = sword_projectile.instance()
			sword_projectile_inst.position = global_position
			$Shoot.pitch_scale = rand_range(0.8, 1.2)
			$Shoot.play(0.0)
			get_parent().get_parent().add_child(sword_projectile_inst)
			yield(get_tree().create_timer(0.3, false), "timeout")
			shoot_cooldown = false


func swing_attack():
	randomize()
	$Swing.pitch_scale = rand_range(0.8, 1.2)
	$Swing.play(0.0)
	$Pivot.look_at(get_global_mouse_position())
	$AnimationPlayer.play("Swing" + str(current_swing))


func _on_Attackbox_on_attack():
	randomize()
	$Hit.pitch_scale = rand_range(0.8, 1.2)
	$Hit.play(0.0)
