extends Camera2D

export var screen_size = Vector2(320, 208)
export var follow : NodePath

func _ready():
	position = get_node(follow).position
	smoothing_enabled = false
	yield(get_tree().create_timer(0.1), "timeout")
	smoothing_enabled = true


func _process(delta):
	if follow != "":
		if get_node(follow) != null:
			position = get_node(follow).position
	position.x = stepify(position.x + (screen_size.x / 2), screen_size.x) - (screen_size.x / 2)
	position.y = stepify(position.y + (screen_size.y / 2), screen_size.y) - (screen_size.y / 2)
