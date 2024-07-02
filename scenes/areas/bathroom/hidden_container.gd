extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = 4
	hide()
	GameEvents.toilet_puzzle_complete.connect(on_complete)
	
func on_complete():
	show()
