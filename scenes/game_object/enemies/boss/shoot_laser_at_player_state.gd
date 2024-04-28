extends State

@export var beam_scene : PackedScene
@export var orb : GirlCultBossOrb

func Enter():
	var player = get_tree().get_first_node_in_group("Player") as Player
	var beam_instance = beam_scene.instantiate() as Line2D
	beam_instance.global_position = orb.center.global_position
	get_tree().get_first_node_in_group("foreground_layer").add_child(beam_instance)
	beam_instance.look_at(player.middle.global_position)
