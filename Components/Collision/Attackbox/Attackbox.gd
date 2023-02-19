extends Area2D


export var ignore : NodePath
export var damage : int
signal on_attack
export var ignore_player = false


func _ready():
	add_to_group("attackbox")


func _on_Attackbox_area_entered(area):
	deal_damage(area)


func deal_damage(area):
	if area.is_in_group("hitbox"):
		if !ignore_player:
			if !is_in_group("enemy"):
				if ignore != "":
					if area != get_node(ignore):
						emit_signal("on_attack")
						area.hit(damage)
				else:
					emit_signal("on_attack")
					area.hit(damage)
			elif is_in_group("enemy"):
				if area.is_in_group("enemy"):
					pass
				else:
					if ignore != "":
						if area != get_node(ignore):
							emit_signal("on_attack")
							area.hit(damage)
			else:
				emit_signal("on_attack")
				area.hit(damage)
		else:
			if !area.get_parent().is_in_group("player"):
				area.hit(damage)
				emit_signal("on_attack")
