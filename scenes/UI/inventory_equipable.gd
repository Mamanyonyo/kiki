class_name InventoryItemUI extends PanelContainer

@export var item_name : String
@export var rect : TextureRect

var active = false

func _ready():
	GameEvents.item_equip.connect(on_item_equip)

func set_icon() -> void:
	#if icon_texture != null: icon = icon_texture
	var image = Image.load_from_file("res://assets/icon/" + item_name + ".png")
	rect.texture = ImageTexture.create_from_image(image)
	
func on_item_equip(id):
	var new_style_box : StyleBoxFlat
	if !active && id == item_name:
		new_style_box = load("res://scenes/UI/inventory_item_equipped_border.tres")
		active = true
	else:
		new_style_box = load("res://scenes/UI/inventory_item_unequipped.tres")
		active = false
	add_theme_stylebox_override("panel", new_style_box)

func _on_gui_input(event: InputEvent) -> void:
	if(event.is_pressed()):
		#TODO no handlear esto por game events caso de querer darle inventario a alguien mas
		GameEvents.emit_item_equip(item_name)
