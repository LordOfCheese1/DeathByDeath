extends Area2D


var web = load("res://Prefabs/Entities/WebTrap/WebTrap.tscn")
var looked = false


func _ready():
	$ParticleSpawner.spawn_at = get_parent()


func _physics_process(delta):
	if !looked:
		looked = true
		look_at(Values.player.position)
	
	position += transform.x * 4


func _on_SpiderWeb_body_entered(body):
	var web_inst = web.instance()
	web_inst.position = position
	get_parent().add_child(web_inst)
	call_deferred("free")
