class_name ChasePlayer extends State

@export var velocity_component : VelocityComponent
@export var enemy : CharacterBody2D
@export var sprite_manager : SpriteManager
@export var range_mod : float = 1

func Update(_delta):
	var player = get_tree().get_first_node_in_group("Player") as Player
	
	if player == null:
		transitioned.emit("BackToOriginalPosition")
		return
	
	if player.global_position.distance_to(enemy.global_position) > enemy.detection_range * range_mod:
		if enemy.wave_spawned: 
			transitioned.emit("ChaseTree")
		else:
			transitioned.emit("BackToOriginalPosition")
		return
		
	if sprite_manager != null:
		var parent = get_parent().get_parent() as BasicEnemy
		sprite_manager.direction = parent.global_position.direction_to(player.global_position)
		print(sprite_manager.direction)
		sprite_manager.absolute_dir = Vector2(round(sprite_manager.direction.x), round(sprite_manager.direction.y))
		
	velocity_component.make_path_to_pos(player.global_position)
	velocity_component.accelerate_to_objective()
