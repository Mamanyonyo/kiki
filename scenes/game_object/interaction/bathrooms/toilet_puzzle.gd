extends Node2D

@export var correct: bool = true
@export var resource: DialogueResource
var flushed = false

func _ready():
	GameEvents.toilet_puzzle_fail.connect(_on_puzzle_fail)

func on_interact():
	print("complete")
	print(GameEvents.toilet_complete)
	if GameEvents.toilet_complete:
		return DialogueManager.show_dialogue_balloon(resource, "complete")
	if flushed:
		return DialogueManager.show_dialogue_balloon(resource, "flushed")
		
	if correct:
		flushed = true
		GameEvents.correct_toilets += 1
		DialogueManager.show_dialogue_balloon(resource, "flush")
		##DIALOGO SE ENCARGA DE SETEAR EL COSO COMPLETO
	else: 
		DialogueManager.show_dialogue_balloon(resource, "flush")
		GameEvents.emit_toilet_puzzle_fail()
		GameEvents.correct_toilets = 0
		
func _on_puzzle_fail():
	if correct: flushed = false
