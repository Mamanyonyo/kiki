extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player") as Player
	player.health_component.died.connect(on_player_death)

func on_player_death():
	get_parent().queue_free()
