class_name StateMachine extends Node

var states : Dictionary = {}

signal new_state_entered(name: String)

@export var current_state: State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(on_child_transition)
		else:
			print("State machine contains child which is not 'State'")
	if current_state != null: current_state.Enter()

func _process(delta):
	if current_state != null:
		current_state.Update(delta)

func on_child_transition(new_state_name: StringName):
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != current_state:
			current_state.Exit()
			new_state.Enter()
			current_state = new_state
			new_state_entered.emit(new_state_name)
	else:
		print("Called transition on a state that does not exist: " + new_state_name)
