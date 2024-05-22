extends Node

@export var dialogue : DialogueResource
@export var title : String = "default"
@export var needed_toilet_for_quest = 3

func _ready():
	GameEvents.toilet_complete = needed_toilet_for_quest

func on_interact():
	DialogueManager.show_dialogue_balloon(dialogue, title)
