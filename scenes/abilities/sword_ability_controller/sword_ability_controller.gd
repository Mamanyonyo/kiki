extends Node

@export var timer_ref: Timer 

@export var sword_ability: PackedScene
@export var damage: float = 5
@export var max_range: float = 150
@export var base_wait_time: float = 2.5

func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	timer_ref.wait_time = base_wait_time

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
	var sword_instance = sword_ability.instantiate() as SwordAbility
	sword_instance.hitbox_component.damage = damage
	var direction_to_enemy = closest_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = direction_to_enemy.angle()
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.global_position = closest_enemy.global_position
	
func speed_upgrade(current_upgrades):
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
	timer_ref.wait_time = base_wait_time * (1 - percent_reduction)
	timer_ref.start()
	
func damage_upgrade(current_upgrades):
	var percent = current_upgrades["sword_damage"]["quantity"] * .1
	damage = damage * (1 + percent)
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	match upgrade.id:
		"sword_rate": speed_upgrade(current_upgrades)
		"sword_damage": damage_upgrade(current_upgrades)
		_: return
