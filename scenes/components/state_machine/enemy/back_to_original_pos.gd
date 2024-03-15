extends State

@export var velocity_component : VelocityComponent
@export var enemy : CharacterBody2D

func Enter():
	if velocity_component.original_position == null:
		transitioned.emit("Standby")
		return
	velocity_component.make_path_to_pos(velocity_component.original_position)

func Update(_delta):
	if enemy.global_position.distance_squared_to(velocity_component.original_position) < 1:
		transitioned.emit("Standby")
		return
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player == null:
		transitioned.emit("Standby")
		return
	if player.global_position.distance_to(enemy.global_position) < enemy.detection_range:
		transitioned.emit("ChasePlayer")

	velocity_component.accelerate_to_objective()
