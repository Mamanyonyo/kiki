extends StaticBody2D


func _on_health_component_died():
	GameEvents.tree = false
	GameEvents.emit_tree_destroyed()
	queue_free()
