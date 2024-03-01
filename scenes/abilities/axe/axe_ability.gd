extends Node2D

var MAX_RADIUS = 100

func _ready():
	var tween = create_tween() as Tween
	tween.tween_method(tween_method, 0, 2, 2)

func tween_method(rotations: float):
	var percent = rotations / 2
	var current_radius = percent * MAX_RADIUS
	var current_direction = Vector2.RIGHT.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group("Player")
