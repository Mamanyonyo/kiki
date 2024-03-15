extends State

@export var velocity_component : VelocityComponent
@export var enemy : CharacterBody2D

func Update(_delta):
	var player = get_tree().get_first_node_in_group("Player") as Player
	
	if player == null:
		transitioned.emit("BackToOriginalPosition")
		return
	
	if player.global_position.distance_to(enemy.global_position) > enemy.detection_range:
		if enemy.wave_spawned: 
			transitioned.emit("ChaseTree")
		else:
			transitioned.emit("BackToOriginalPosition")
		return
		
	velocity_component.make_path_to_pos(player.global_position)
	velocity_component.accelerate_to_objective()
