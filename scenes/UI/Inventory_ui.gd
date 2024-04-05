extends GridContainer
@export var inventory_component : InventoryComponent
@onready var item_ui_scene : PackedScene = preload("res://scenes/UI/inventory_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory_component.added_item.connect(on_new_item)
	
func on_new_item(item):
	var item_ui_scene_instance : InventoryItemUI = item_ui_scene.instantiate()
	item_ui_scene_instance.item_name = item
	item_ui_scene_instance.set_icon()
	add_child(item_ui_scene_instance)
