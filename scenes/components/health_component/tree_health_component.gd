extends HealthComponent

func _on_death():
	GameEvents.emit_tree_destroyed()
	GameEvents.tree = false
