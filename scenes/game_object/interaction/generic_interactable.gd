class_name GenericInteractable extends Node2D

@export var dialogue : DialogueResource
@export var title : String = "default"

@export var delete_on_finish = false

signal finish


func interaction():
	if dialogue:
		DialogueManager.show_dialogue_balloon(dialogue, title)
		DialogueManager.dialogue_ended.connect(on_finish_dialogue)
	else: 
		finish_interaction()
	
func finish_interaction():
	finish.emit()
	if delete_on_finish: queue_free()

func on_interact():
	interaction()

func on_finish_dialogue(incoming_dialogue):
	if !dialogue && dialogue != incoming_dialogue: return
	finish_interaction()
