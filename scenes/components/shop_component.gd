class_name ShopComponent extends Node

@export var shop_name : String
@export var items_name : Array[String]
@export var prices : Array[float]

var items = []

signal updated_shop


func _ready():
	var i = 0
	for item in items_name:
		items.push_back({
			"item_id": item,
			"price": prices[i]
		})
		i += 1
	GameEvents.load_shop.connect(on_load_shop)
	
func sell(item_id):
	var i = find_index(item_id)
	items.remove_at(i)
	var player_inventory = get_tree().get_first_node_in_group("Player").get_node("InventoryComponent") as InventoryComponent
	player_inventory.add_item(item_id)
	updated_shop.emit()
	
func find_index(item_id):
	var i = 0
	for item in items:
		if item["item_id"] == item_id: return i
		i += 1

func on_load_shop(name):
	if shop_name != name: return
	GameEvents.emit_shop_open(self)
	
