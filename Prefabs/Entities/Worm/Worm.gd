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
	for i in get_children():
		if i.name != "Head" && (abs(previous_seg_pos.x - i.global_position.x) + abs(previous_seg_pos.y - i.global_position.y)) > 12:
			i.global_position.x += (previous_seg_pos.x - i.global_position.x) / 3
			i.global_position.y += (previous_seg_pos.y - i.global_position.y) / 3
		previous_seg_pos = i.global_position
		i.position.y += gravity
	
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
				i.position.x = Values.player.position.x - 20
				i.position.y = Values.player.position.y - 320


func _on_Head_on_attack():
	$Head/CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.3, false), "timeout")
	$Head/CollisionShape2D.disabled = false
