extends Node

@export var dialogue : DialogueResource
@export var title : String = "default"


func on_interact():
	DialogueManager.show_dialogue_balloon(dialogue, title)
