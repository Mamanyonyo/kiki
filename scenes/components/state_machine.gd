class_name StateMachine extends Node

var states : Dictionary = {}

@export var current_state: State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(on_child_transition)
		else:
			push_warning("State machine contains child which is not 'State'")

func _process(delta):
	if current_state:
		current_state.Update(delta)

func on_child_transition(new_state_name: StringName):
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != current_state:
			current_state.Exit()
			new_state.Enter()
			current_state = new_state
	else: 
		push_warning("Called transition on a state that does not exist")
