extends Node2D


export var current_swing = 0
export var should_turn = true
var can_attack = true
export var emit_particles = true
var shoot_cooldown = false

var sword_projectile = load("res://Prefabs/Projectiles/SwordProjectile/SwordProjectile.tscn")


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
	if Values.bow:
		if Input.is_action_just_pressed("shoot") && !shoot_cooldown:
			if get_parent().is_in_group("player"):
				get_parent().velocity.y += -$Pivot.transform.x.y * 50
				get_parent().velocity.x += stepify(-$Pivot.transform.x.x * 80, 12)
			shoot_cooldown = true
			var sword_projectile_inst = sword_projectile.instance()
			sword_projectile_inst.position = global_position
			get_parent().get_parent().add_child(sword_projectile_inst)
			yield(get_tree().create_timer(0.3, false), "timeout")
			shoot_cooldown = false


func swing_attack():
	$Pivot.look_at(get_global_mouse_position())
	$AnimationPlayer.play("Swing" + str(current_swing))
