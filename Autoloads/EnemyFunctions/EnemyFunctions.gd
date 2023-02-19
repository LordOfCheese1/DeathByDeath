extends Node2D


func distance(point_a : Vector2, point_b : Vector2):
	var dis_x = 0.0
	var dis_y = 0.0
	
	if point_a.x > point_b.x:
		dis_x = point_a.x - point_b.x
	elif point_a.x < point_b.x:
		dis_x = point_b.x - point_a.x
	
	if point_a.y > point_b.y:
		dis_y = point_a.y - point_b.y
	elif point_a.y < point_b.y:
		dis_y = point_b.y - point_a.y
	
	return Vector2(dis_x, dis_y)
