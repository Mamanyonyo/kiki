extends StaticBody2D

@export var item_id : String
@export var dialogue : DialogueResource
@export var title : String = "default"

func on_interact():
	var player_inventory = get_tree().get_first_node_in_group("Player").inventory_component as InventoryComponent
	#TODO revisar si invent esta lleno
	player_inventory.add_item(item_id)
	#WARNING no muy elegante
	GameEvents.last_obtained_item = capitalizeWords(item_id)
	DialogueManager.show_dialogue_balloon(dialogue, title)
	queue_free()

func capitalizeWords(sentence: String) -> String:
	var words = sentence.split(" ")
	var result = ""
	for word in words:
		var capitalized_word = word.capitalize()
		result += capitalized_word + " "
	return result.strip_edges()
