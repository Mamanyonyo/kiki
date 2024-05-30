extends Node

@export var sfx_name = "Laser"

func _process(delta: float) -> void:
	get_tree().get_first_node_in_group("sound").play_if_not_playing(sfx_name)
