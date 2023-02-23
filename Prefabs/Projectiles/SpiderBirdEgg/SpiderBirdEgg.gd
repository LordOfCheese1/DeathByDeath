extends KinematicBody2D


var bird = load("res://Prefabs/Entities/Stultuvem/Stultuvem.tscn")
var mini_spider = load("res://Prefabs/Entities/Pauluculmus/Pauluculmus.tscn")
var spider = load("res://Prefabs/Entities/Reptansulus/Reptansulus.tscn")

var is_dead = false


func _ready():
	scale = Vector2(0, 0)


func _physics_process(delta):
	if !is_dead:
		scale.x += 0.005
		scale.y = scale.x


func hatch(broke_in_time : bool):
	randomize()
	if broke_in_time:
		var mini_spider_inst = mini_spider.instance()
		mini_spider_inst.position.y = position.y - 12
		mini_spider_inst.position.x = position.x
		get_parent().add_child(mini_spider_inst)
	else:
		var spider_inst = spider.instance()
		spider_inst.position.y = position.y - 16
		spider_inst.position.x = position.x
		var bird_inst = bird.instance()
		bird_inst.position.y = position.y - 16
		bird_inst.position.x = position.x
		get_parent().add_child(bird_inst)
		get_parent().add_child(spider_inst)
	is_dead = true
