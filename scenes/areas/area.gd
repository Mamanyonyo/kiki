class_name Area extends Node


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
