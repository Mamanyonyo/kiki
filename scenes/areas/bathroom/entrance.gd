extends Area

@export var dialogue : DialogueResource

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		DialogueManager.show_dialogue_balloon(dialogue)
