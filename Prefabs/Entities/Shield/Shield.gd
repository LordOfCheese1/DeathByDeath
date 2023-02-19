extends Node2D


export var durability : int
export var hitbox_to_protect : NodePath
signal shield_down


func _ready():
	$HealthManager.max_health = durability
	$HealthManager.health = $HealthManager.max_health


func _process(delta):
	if get_node(hitbox_to_protect).is_in_group("hitbox") && get_node(hitbox_to_protect).monitoring:
		get_node(hitbox_to_protect).monitoring = false
		get_node(hitbox_to_protect).monitorable = false


func _on_Hitbox_on_hit():
	$AnimationPlayer.play("Block")
	$Explosion.emitting = true


func _on_HealthManager_health_depleted():
	$Hitbox/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Destroy")
	yield(get_tree().create_timer(0.2, false), "timeout")
	emit_signal("shield_down")
	yield(get_tree().create_timer(0.5), "timeout")
	if get_node(hitbox_to_protect).is_in_group("hitbox"):
		get_node(hitbox_to_protect).monitoring = true
		get_node(hitbox_to_protect).monitorable = true
	call_deferred("free")
