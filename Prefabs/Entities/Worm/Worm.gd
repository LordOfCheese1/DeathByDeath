extends Node2D


var previous_seg_pos = Vector2()
var hunting_phase = 0
var hunting_cooldown = 100
var hit_multiplier = 1
var gravity = 0.4


func _ready():
	pass


func _physics_process(delta):
	if hunting_phase > 0:
		$Head.look_at(Values.player.position)
	else:
		$Head.look_at(Values.player.position)
		$Head.rotation_degrees = $Head.rotation_degrees * -1
	if EnemyFunctions.distance(Values.player.position, $Head.global_position).x < 400 && EnemyFunctions.distance(Values.player.position, $Head.global_position).y < 400:
		$Head.position += $Head.transform.x * 2
		previous_seg_pos = $Head.global_position
		var seg_multiplier = 2.8
		for i in get_children():
			if i.name != "Head" && (abs(previous_seg_pos.x - i.global_position.x) + abs(previous_seg_pos.y - i.global_position.y)) > 8:
				i.global_position.x += (previous_seg_pos.x - i.global_position.x) / 3
				i.global_position.y += (previous_seg_pos.y - i.global_position.y) / 3
			if hunting_phase > 0:
				i.position.y += gravity * seg_multiplier
				i.position.x += ($Head.position.x - i.position.x) / 64
			previous_seg_pos = i.global_position
			seg_multiplier -= 0.15
	
	if hunting_phase > 0:
		hunting_phase -= 1
		hunting_cooldown = 600
	else:
		if hunting_cooldown > 0:
			hunting_cooldown -= 1
		else:
			hunting_cooldown = 600
			hunting_phase = 450
			print("Attack")
			for i in get_children():
				i.global_position.x = Values.player.position.x - rand_range(-60, 60)
				i.global_position.y = Values.player.position.y - 300


func _on_Head_on_attack():
	$Head/CollisionShape2D.position.y = -1000 * 1000
	yield(get_tree().create_timer(0.4, false), "timeout")
	$Head/CollisionShape2D.position.y = 0


func _on_VisibilityEnabler2D_screen_entered():
	show()


func _on_VisibilityEnabler2D_screen_exited():
	hide()
