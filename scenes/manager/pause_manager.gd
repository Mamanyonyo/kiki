extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.dialogue_ended.connect(on_dialogue_end)
	DialogueManager.passed_title.connect(on_dialogue_start)
	
	
func on_dialogue_end(_dialogue):
	get_tree().paused = false
	
func on_dialogue_start(_title):
	get_tree().paused = true
