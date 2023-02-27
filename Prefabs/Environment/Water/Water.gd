extends Area2D


export var water_size : Vector2
var collidershape = RectangleShape2D.new()


func _ready():
	add_to_group("water")
	collidershape.extents = water_size / 2
	$WaterTile.scale = water_size / 16
	$CollisionShape2D.shape = collidershape
	$WaterTile.material.set_shader_param("tile", water_size / 16)
