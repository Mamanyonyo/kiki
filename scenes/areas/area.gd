class_name Area extends Node

@onready var tilemap = $TileMap

var in_area = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var entities_node = get_node("TileMap/Entities")
	if entities_node != null:
		var entities_node_array = entities_node.get_children()
		var main_entities_node = get_tree().get_first_node_in_group("entities_layer")
		for entity in entities_node_array:
			entity.reparent(main_entities_node)
		entities_node.queue_free()
	else: print("area " + name + " has no entities node")
	if has_method("my_ready"):
		call("my_ready")

func _process(_float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if !player: return
	var tilemap_size = tilemap.get_used_rect().size * 16
	var tilemap_pos = tilemap.global_position + Vector2(tilemap.get_used_rect().position * 16)
	var tilemap_end_points = Vector2(tilemap_size) + tilemap_pos
	
	
	if player.global_position.x > tilemap_pos.x && player.global_position.x < tilemap_end_points.x && player.global_position.y > tilemap_pos.y && player.global_position.y < tilemap_end_points.y:
		if !in_area: Enter()
	elif(in_area): Leave()

func Enter():
	in_area = true
	print("Entered " + name)
	pass
	
func Leave():
	in_area = false
	print("Left " + name)
	pass
