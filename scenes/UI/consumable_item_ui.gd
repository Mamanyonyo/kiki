class_name ConsumableInventoryItemUI extends InventoryItem

var item_manager : ItemManager
var inventory_component : InventoryComponent

func _ready():
		item_manager = get_tree().get_first_node_in_group("Player").get_node("ItemManager")
		inventory_component = get_tree().get_first_node_in_group("Player").get_node("InventoryComponent")

func _on_gui_input(event: InputEvent) -> void:
	if(event.is_pressed()):
		match DataImport.consumable_data[item_name].type:
			"scroll": item_manager.learn_spell(DataImport.consumable_data[item_name].spell)
			
	inventory_component
