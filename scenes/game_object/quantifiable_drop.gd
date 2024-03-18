class_name quantifiable_drop extends Node2D

@export var value : int = 1

func tween_collect(percent: float, start_position):
	var player = get_tree().get_first_node_in_group("Player")
	if player == null: return
	
	global_position = start_position.lerp(player.global_position, percent)

func set_value(new: int):
	value = new

func collect():
	pass

func _on_area_2d_area_entered(area):
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_callback(collect)
