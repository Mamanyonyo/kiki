extends Node

@export var droppeable: PackedScene = preload("res://scenes/game_object/experience_vial/experience_vial.tscn")
@export var health_component: HealthComponent

func _ready():
	health_component.died.connect(on_death)
	
func on_death():
	if droppeable == null: return
	var spawn_position = owner.global_position
	var drop_instance = droppeable.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
	entities_layer.add_child(drop_instance)
	drop_instance.global_position = spawn_position
