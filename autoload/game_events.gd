extends Node

signal experience_vial_collected(exp: float)

# Called when the node enters the scene tree for the first time.
func emit_experience_vial_collected(exp: float):
	experience_vial_collected.emit(exp)
