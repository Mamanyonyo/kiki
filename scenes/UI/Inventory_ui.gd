extends GridContainer
@onready var equipable_ui_scene : PackedScene = preload("res://scenes/UI/inventory_item.tscn")
@onready var consumable_ui_scene : PackedScene = preload("res://scenes/UI/inventory_item_consumable.tscn")

var inventory_component : InventoryComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_ready.connect(on_player_ready)
	
func reload_inventory():
	remove_all_children()
	for item in inventory_component.items:
		load_item(item)

func load_item(item):
	if DataImport.item_data[item].type == "consumable":
		instance_scene(consumable_ui_scene, item)
	else:
		instance_scene(equipable_ui_scene, item)

func instance_scene(scene, item):
	var item_ui_scene_instance = scene.instantiate()
	item_ui_scene_instance.item_name = item
	item_ui_scene_instance.set_icon()
	add_child(item_ui_scene_instance)

func on_player_ready():
	inventory_component = get_tree().get_first_node_in_group("Player").get_node("InventoryComponent")
	inventory_component.updated_inventory.connect(on_added_item)
	reload_inventory()

func remove_all_children():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()

func on_added_item():
	reload_inventory()
