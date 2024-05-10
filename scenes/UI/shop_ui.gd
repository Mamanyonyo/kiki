extends PanelContainer

@onready var item_scene = preload("res://scenes/UI/shop_item_ui.tscn")
@onready var container = $MarginContainer/TiendaContainer

var current_shop : ShopComponent

func _ready():
	GameEvents.shop_open.connect(on_shop_open)
	
func _process(float):
	if visible:
		var player = get_tree().get_first_node_in_group("Player") as Player
		if player.get_node("SpriteManager").direction != Vector2.ZERO || Input.is_key_pressed(KEY_ESCAPE): close()
	
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

func close():
	visible = false
	current_shop.disconnect("updated_shop", on_shop_update)
	current_shop = null

func _input(event: InputEvent):
	if visible && event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var evLocal = make_input_local(event)
		if !Rect2(Vector2(0,0), size).has_point(evLocal.position):
			close()
