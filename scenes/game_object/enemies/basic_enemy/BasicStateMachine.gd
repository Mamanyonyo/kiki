class_name StateMachine extends Node

@export var detection_range : float = 100
@export var velocity_component : VelocityComponent

var states : Dictionary = {}

enum {
	GET_TREE_DIRECTION,
	CHASE_TREE,
	CHASE_PLAYER,
	GET_ORIGINAL_POS_DIR,
	STANDBY,
	BACK_TO_ORIGINAL_POS
}

var state = STANDBY

#func _ready():
	#for child in get_children():
		#if child is State:
			#states[child.name] = child

func _process(_delta) -> void:
	match state:
		STANDBY:
			chase_tree_if_wave_spawned()
			check_if_is_in_detection_range()
		GET_TREE_DIRECTION:
			if GameEvents.tree:
				velocity_component.make_path("tree")
				state = CHASE_TREE
			else:
				state = STANDBY
		CHASE_TREE:
			check_if_is_in_detection_range()
			velocity_component.accelerate_to_objective()
		GET_ORIGINAL_POS_DIR:
			velocity_component.make_path_to_pos(velocity_component.original_position)
			state = BACK_TO_ORIGINAL_POS
		BACK_TO_ORIGINAL_POS:
			check_if_is_in_detection_range()
			velocity_component.accelerate_to_objective()
		CHASE_PLAYER:
			check_if_is_in_detection_range()
			velocity_component.make_path("Player")
			velocity_component.accelerate_to_objective()

func check_if_is_in_detection_range():
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null:
		state = STANDBY
		return
	var owner_node2d = owner as CharacterBody2D
	if player.global_position.distance_to(owner_node2d.global_position) < detection_range:
		state = CHASE_PLAYER
	else:
		if owner_node2d.wave_spawned: state = GET_TREE_DIRECTION
		else:
			if state != BACK_TO_ORIGINAL_POS: state = GET_ORIGINAL_POS_DIR

func chase_tree_if_wave_spawned():
	var owner_node2d = owner as Node2D
	if owner_node2d.wave_spawned:
		state = GET_TREE_DIRECTION
	else:
		state = STANDBY
