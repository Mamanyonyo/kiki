extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.debug = true
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_P): 
		GameEvents.debug = !GameEvents.debug
