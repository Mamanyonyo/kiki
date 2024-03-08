extends Node2D

@export var tilemap: TileMap
@export var area_node: Area2D
@export var boss_spawn_point: Marker2D

var bathroom_ghost_boss_scene: PackedScene = load("res://scenes/game_object/enemies/mini_boss/bathroom_ghost_boss.tscn")
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		tilemap.set_layer_enabled(2, true)
		area_node.queue_free()
		fight_start()

func fight_start():
	var ghost_instance = bathroom_ghost_boss_scene.instantiate()
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(ghost_instance)
	ghost_instance.global_position = boss_spawn_point.global_position
	ghost_instance.tilemap = tilemap
