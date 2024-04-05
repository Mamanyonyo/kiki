extends MarginContainer

@export var item_name : String


func _on_gui_input(event: InputEvent) -> void:
	if(event.is_pressed()):
		GameEvents.emit_item_equip(item_name)
