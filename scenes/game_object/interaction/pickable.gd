extends StaticBody2D

@export var item_id : String

func on_interact():
	var player_inventory = get_tree().get_first_node_in_group("Player").inventory_component as InventoryComponent
	player_inventory.add_item(item_id)
	queue_free()
