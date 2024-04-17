class_name InventoryComponent extends Node

@export var items : Array[String]

signal updated_inventory

func add_item(item):
	items.push_back(item)
	updated_inventory.emit()

func remove_item(item):
	var i = items.find(item)
	items.remove_at(i)
	updated_inventory.emit()
