extends Area2D

@export var boss_spawn_point: Marker2D
@export var tilemap : TileMap

@export var block_layer = 5
@export var horizontal = 9
@export var vertical = 6

@export var bathroom_ghost_boss_scene: PackedScene

var top : float

func fight_start():
	var ghost_instance = bathroom_ghost_boss_scene.instantiate() as BathroomGhostBoss
	var ghost_health_comp = ghost_instance.health_component as HealthComponent
	ghost_instance.global_position = boss_spawn_point.global_position
	ghost_instance.tilemap = tilemap
	ghost_instance.vertical = vertical
	ghost_instance.horizontal = horizontal
	ghost_instance.block_layer = block_layer
	top = block_layer + 1
	tilemap.add_layer(top)
	ghost_instance.top = block_layer + 1
	ghost_health_comp.died.connect(on_ghost_death)
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.call_deferred("add_child", ghost_instance)
	set_deferred("monitoring", false)

func _on_area_entered(area):
	if area.get_parent().get_parent().is_in_group("Player"):
		tilemap.set_layer_enabled(block_layer, true)
		fight_start()
		
func on_ghost_death():
	tilemap.set_layer_enabled(block_layer, false)
	tilemap.set_layer_enabled(top, false)
