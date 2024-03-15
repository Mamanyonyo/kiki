extends State

@export var velocity_component : VelocityComponent
@export var enemy : CharacterBody2D

func Enter():
	if !GameEvents.tree:
		transitioned.emit("Standby")
		return
	velocity_component.make_path("tree")
	
func Update(_delta):
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player != null:
		if player.global_position.distance_to(enemy.global_position) < enemy.detection_range:
			transitioned.emit("ChasePlayer")
			return

	velocity_component.accelerate_to_objective()
	
