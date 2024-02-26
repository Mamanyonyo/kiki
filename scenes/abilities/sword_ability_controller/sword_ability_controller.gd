extends Node

@export var sword_ability: PackedScene

@export var max_range: float = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("Player") as Node2D
	var enemies = get_tree().get_nodes_in_group("Enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2))
	if enemies.size() == 0:
		return
		
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	var closest_enemy = enemies[0] as Node2D
	var sword_instance = sword_ability.instantiate() as Node2D
	var direction_to_enemy = closest_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = direction_to_enemy.angle()
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	player.get_parent().add_child(sword_instance)
	sword_instance.global_position = closest_enemy.global_position
