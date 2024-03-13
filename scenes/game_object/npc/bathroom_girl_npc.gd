extends Node2D

@export var dialogue : DialogueResource
@export var title : String

func on_interact():
	DialogueManager.show_dialogue_balloon(dialogue, title)
