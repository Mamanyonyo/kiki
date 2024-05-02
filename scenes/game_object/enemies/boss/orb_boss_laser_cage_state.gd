extends State

@export var orb : GirlCultBossOrb
@export var distance_from_player = 86
@export var starting_direction = Vector2.RIGHT

@export var laser_scene : PackedScene

func Enter():
	var player = get_tree().get_first_node_in_group("Player") as Player
	var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
	var i = 0
	var this_orb_index : float
	for current_orb : GirlCultBossOrb in orbs:
		if current_orb.get_rid() == orb.get_rid(): this_orb_index = i
		i += 1
	var next_orb_index = this_orb_index + 1
	if next_orb_index == orbs.size() : next_orb_index = 0
	var angle_degrees = this_orb_index * 90
	var angle = deg_to_rad(angle_degrees)
	var rotation_vector = starting_direction.rotated(angle) as Vector2
	orb.global_position = player.global_position + rotation_vector * distance_from_player
	var next_orb = orbs[next_orb_index] as GirlCultBossOrb
	var laser_target = next_orb.center.global_position
	var laser_instance = laser_scene.instantiate() as Line2D
	get_tree().get_first_node_in_group("entities_layer").add_child.call_deferred(laser_instance)
	laser_instance.global_position = orb.center.global_position
	laser_instance.look_at(laser_target)
