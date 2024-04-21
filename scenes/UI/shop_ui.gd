extends PanelContainer

@onready var item_scene = preload("res://scenes/UI/shop_item_ui.tscn")
@onready var container = $MarginContainer/TiendaContainer

var current_shop : ShopComponent

func _ready():
	GameEvents.shop_open.connect(on_shop_open)
	
func on_shop_open(shop):
	visible = true
	if current_shop != null:
		current_shop.disconnect("updated_shop", on_shop_update)
	current_shop = shop
	current_shop.connect("updated_shop", on_shop_update)
	on_shop_update()

func on_shop_update():
	for n in container.get_children():
		container.remove_child(n)
		n.queue_free()

	var i = 0
	for item in current_shop.items:
		var instance = item_scene.instantiate()
		instance.set_data(item.item_id, current_shop.prices[i], current_shop)
		container.add_child(instance)
