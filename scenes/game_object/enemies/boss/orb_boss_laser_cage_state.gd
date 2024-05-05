extends State

@export var orb : GirlCultBossOrb
@export var distance_from_player = 86
@export var starting_direction = Vector2.RIGHT

@export var laser_scene : PackedScene
var laser_instance : Line2D

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
	var looking_towards_orb_angle = deg_to_rad(angle_degrees + 180 + 45)
	var rotation_vector = starting_direction.rotated(angle) as Vector2
	var laser_rotation = looking_towards_orb_angle
	orb.global_position = player.global_position + rotation_vector * distance_from_player
	laser_instance = laser_scene.instantiate()
	get_tree().get_first_node_in_group("entities_layer").add_child.call_deferred(laser_instance)
	laser_instance.global_position = orb.center.global_position
	laser_instance.points[1] = Vector2.RIGHT * (distance_from_player/2 + distance_from_player)
	laser_instance.rotate(looking_towards_orb_angle)
	
func Update(delta):
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player.global_position.distance_to(orb.global_position) > distance_from_player * 2:
		var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
		for orb : GirlCultBossOrb in orbs:
			if orb.state_machine.current_state.name == name:
				orb.state_machine.current_state.Exit()
				orb.state_machine.current_state.Enter()

func Exit():
	laser_instance.queue_free()


func _on_health_component_died():
	if orb.state_machine.current_state.name != name: return
	laser_instance.queue_free()
	var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
	var first_orb = orbs[0] as GirlCultBossOrb
	if first_orb.girl.state_machine.current_state.name == "Casting" && !first_orb.girl.state_machine.current_state.leaving:
		first_orb.girl.state_machine.current_state.leave()
