extends GridContainer
@onready var item_ui_scene : PackedScene = preload("res://scenes/UI/inventory_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_ready.connect(on_player_ready)
	
func on_new_item(item):
	var item_ui_scene_instance : InventoryItemUI = item_ui_scene.instantiate()
	item_ui_scene_instance.item_name = item
	item_ui_scene_instance.set_icon()
	add_child(item_ui_scene_instance)

func on_player_ready(player):
	player.get_node("InventoryComponent").added_item.connect(on_new_item)
	on_new_item("book")
