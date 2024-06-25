class_name InventoryItem extends PanelContainer

@export var item_name : String
@export var rect : TextureRect

func set_icon() -> void:
	#if icon_texture != null: icon = icon_texture
	rect.texture = load("res://assets/icon/" + item_name + ".png")
