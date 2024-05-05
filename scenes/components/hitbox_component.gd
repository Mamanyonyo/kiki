extends Area2D
class_name HitboxComponent


@export var attacker : Node2D
@export var damage: float = 0
@export var altered_state : String

func target_player():
	set_collision_layer_value(9, true)
	
func target_enemy():
	set_collision_layer_value(3, true)
	
func target_only_enemy():
	target_enemy()
	set_collision_layer_value(9, false)
	
func target_only_player():
	target_player()
	set_collision_layer_value(3, false)
