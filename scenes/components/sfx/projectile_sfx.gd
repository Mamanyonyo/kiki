class_name ProjectileSFX extends Node

@export var sfx_name = "Fireball"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_first_node_in_group("sound").play(sfx_name)
