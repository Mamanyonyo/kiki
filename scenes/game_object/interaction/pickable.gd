class_name Pickable extends StaticBody2D

@export var item_id : String
@export var dialogue : DialogueResource
@export var title : String = "default"
@export var sprite_2d : Sprite2D

signal picked_up

func on_interact():
	var player_inventory = get_tree().get_first_node_in_group("Player").inventory_component as InventoryComponent
	#TODO revisar si invent esta lleno
	player_inventory.add_item(item_id)
	#WARNING no muy elegante
	GameEvents.last_obtained_item = DataImport.item_data[item_id].name
	DialogueManager.show_dialogue_balloon(dialogue, title)
	picked_up.emit()
	queue_free()

func set_data(id):
	item_id = id
