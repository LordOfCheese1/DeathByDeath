extends StaticBody2D


export var entity : NodePath
export var required_distance : float #negative if player is coming from the right, positive if from the left
var entity_defeated = false
export var from_left : bool
var onscreen = false


func _ready():
	$AnimationPlayer.play("Open")


func _process(delta):
	
	if !entity_defeated && $CollisionShape2D.disabled:
		if EnemyFunctions.distance(Values.player.position, position).y < 64:
			if Values.player.position.x > position.x && from_left:
				if EnemyFunctions.distance(Values.player.position, position).x > required_distance:
					$AnimationPlayer.play("Close")
					if onscreen && !$Close.playing:
						$Close.play(0.0)
			elif Values.player.position.x < position.x && !from_left:
				if EnemyFunctions.distance(Values.player.position, position).x > required_distance:
					$AnimationPlayer.play("Close")
					if onscreen && !$Close.playing:
						$Close.play(0.0)
	
	if !entity_defeated && EnemyFunctions.distance(Values.player.position, position).y > 160:
		$AnimationPlayer.play("Open")
	
	if get_node_or_null(entity) == null && !$CollisionShape2D.disabled:
		entity_defeated = true
		$AnimationPlayer.play("Open")


func _on_VisibilityEnabler2D_screen_entered():
	onscreen = true


func _on_VisibilityEnabler2D_screen_exited():
	onscreen = false
