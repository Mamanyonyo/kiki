class_name InventoryComponent extends Node

@export var items : Array[String]

signal added_item(item_id)

func add_item(item):
	items.push_back(item)
	added_item.emit(item)
