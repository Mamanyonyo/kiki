class_name InventoryComponent extends Node

@export var items : Array

signal added_item

func add_item(item):
	items.push_back(item)
	added_item.emit(item)
