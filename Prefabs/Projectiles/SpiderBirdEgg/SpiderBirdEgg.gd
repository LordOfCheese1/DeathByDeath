extends KinematicBody2D


var bird = load("res://Prefabs/Entities/Stultuvem/Stultuvem.tscn")
var mini_spider = load("res://Prefabs/Entities/Pauluculmus/Pauluculmus.tscn")
var spider = load("res://Prefabs/Entities/Reptansulus/Reptansulus.tscn")

var is_dead = false
var gravity = 50


func _ready():
	scale = Vector2(0.05, 0.05)
	$Hitbox.add_to_group("enemy")


func _physics_process(delta):
	move_and_slide(Vector2(0, gravity))
	if gravity < 300:
		gravity += 3
	if !is_dead:
		scale.x += 0.005
		scale.y = scale.x
		if scale.x >= 1:
			hatch(false)
			yield(get_tree().create_timer(0.2, false), "timeout")
			call_deferred("free")


func hatch(broke_in_time : bool):
	randomize()
	if broke_in_time:
		var mini_spider_inst = mini_spider.instance()
		mini_spider_inst.position.y = position.y - 32
		mini_spider_inst.position.x = position.x
		get_parent().add_child(mini_spider_inst)
	else:
		var spider_inst = spider.instance()
		spider_inst.position.y = position.y - 32
		spider_inst.position.x = position.x
		var bird_inst = bird.instance()
		bird_inst.position.y = position.y - 32
		bird_inst.position.x = position.x
		get_parent().add_child(bird_inst)
		get_parent().add_child(spider_inst)
	is_dead = true
	$AnimationPlayer.play("Death")


func _on_Hitbox_on_hit():
	if !is_dead:
		$AnimationPlayer.play("Hit")


func _on_HealthManager_health_depleted():
	if !is_dead:
		is_dead = true
		hatch(true)
		yield(get_tree().create_timer(0.2, false), "timeout")
		call_deferred("free")
