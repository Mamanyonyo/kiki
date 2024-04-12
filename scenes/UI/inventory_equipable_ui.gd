class_name InventoryItemUI extends PanelContainer

@export var item_name : String
@export var rect : TextureRect

var weapon_manager : WeaponManager
var hat_manager : HatManager

var active = false

func _ready():
	weapon_manager = get_tree().get_first_node_in_group("Player").get_node("WeaponManager")
	hat_manager = get_tree().get_first_node_in_group("Player").get_node("HatManager")
	weapon_manager.item_equip.connect(on_weapon_equip)
	hat_manager.item_equip.connect(on_hat_equip)

func set_icon() -> void:
	#if icon_texture != null: icon = icon_texture
	var image = Image.load_from_file("res://assets/icon/" + item_name + ".png")
	rect.texture = ImageTexture.create_from_image(image)

	
func on_weapon_equip():
	if DataImport.item_data[item_name].type != "weapon": return
	var current_weapon : MagicWeaponController = weapon_manager.current_controller
	on_item_equip(current_weapon.item_id)
	
func on_hat_equip():
	if DataImport.item_data[item_name].type != "hat": return
	var current_hat : EquipmentController = hat_manager.current_controller
	if current_hat == null: 
		set_unactive()
		return
	on_item_equip(current_hat.item_id)
	
func on_item_equip(id: String):
	if DataImport.item_data[item_name].type != DataImport.item_data[id].type: return
	var new_style_box : StyleBoxFlat
	if !active && id == item_name:
		new_style_box = load("res://scenes/UI/inventory_item_equipped_border.tres")
		active = true
	else:
		new_style_box = load("res://scenes/UI/inventory_item_unequipped.tres")
		active = false
	add_theme_stylebox_override("panel", new_style_box)

func set_unactive():
	var new_style_box : StyleBoxFlat
	new_style_box = load("res://scenes/UI/inventory_item_unequipped.tres")
	active = false
	add_theme_stylebox_override("panel", new_style_box)

func _on_gui_input(event: InputEvent) -> void:
	if(event.is_pressed()):
		match DataImport.item_data[item_name].type:
			"weapon": weapon_manager.equip_item(item_name)
			"hat": hat_manager.equip_item(item_name)
