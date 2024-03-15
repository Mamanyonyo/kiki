extends BasicEnemy

@export var state_machine : StateMachine

func _on_health_component_health_changed() -> void:
	state_machine.on_child_transition("ChasePlayer")
