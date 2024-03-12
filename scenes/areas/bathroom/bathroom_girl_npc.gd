extends Node2D

@export var dialogue : DialogueResource

func on_interact():
	DialogueManager.show_dialogue_balloon(dialogue, "talk_to_bathroom_girl")
