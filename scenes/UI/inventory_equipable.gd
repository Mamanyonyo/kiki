class_name InventoryItemUI extends PanelContainer

@export var item_name : String
@export var rect : TextureRect

var weapon_manager : WeaponManager

var active = false

func _ready():
	weapon_manager = get_tree().get_first_node_in_group("Player").get_node("WeaponManager")
	weapon_manager.weapon_item_equip.connect(on_weapon_equip)
	on_weapon_equip()

func set_icon() -> void:
	#if icon_texture != null: icon = icon_texture
	var image = Image.load_from_file("res://assets/icon/" + item_name + ".png")
	rect.texture = ImageTexture.create_from_image(image)
	
func on_weapon_equip():
	var new_style_box : StyleBoxFlat
	var current_weapon : MagicWeaponController = weapon_manager.current_weapon_controller
	if !active && current_weapon.item_id == item_name:
		new_style_box = load("res://scenes/UI/inventory_item_equipped_border.tres")
		active = true
	else:
		new_style_box = load("res://scenes/UI/inventory_item_unequipped.tres")
		active = false
	add_theme_stylebox_override("panel", new_style_box)

func _on_gui_input(event: InputEvent) -> void:
	if(event.is_pressed()):
		weapon_manager.equip_item(item_name)
