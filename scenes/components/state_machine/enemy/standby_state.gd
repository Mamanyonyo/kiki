class_name Standby extends State

@export var enemy : CharacterBody2D

func Update(_delta):
	if enemy.wave_spawned && GameEvents.tree:
		transitioned.emit("ChaseTree")
		return
	var player = get_tree().get_first_node_in_group("Player") as Player
	
	if player != null:
		if player.global_position.distance_to(enemy.global_position) < enemy.detection_range:
			transitioned.emit("ChasePlayer")
			return
