class_name InventoryItemUI extends MarginContainer

@export var item_name : String
@export var rect : TextureRect

func set_icon() -> void:
	#if icon_texture != null: icon = icon_texture
	var image = Image.load_from_file("res://assets/icon/" + item_name + ".png")
	rect.texture = ImageTexture.create_from_image(image)

func _on_gui_input(event: InputEvent) -> void:
	if(event.is_pressed()):
		GameEvents.emit_item_equip(item_name)
