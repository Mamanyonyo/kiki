extends BasicEnemy

func _on_health_component_changed() -> void:
	state_machine.on_child_transition("ChasePlayer")
