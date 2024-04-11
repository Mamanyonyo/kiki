class_name HatManager extends Node

@export var player : CharacterBody2D
@export var hat_sprite : HatSprite
#var current_hat_controller
var current_hat : String = ""
signal item_equip

#func _unhandled_input(event: InputEvent) -> void:
	#current_hat_controller.Inputs()

func equip_item(item: String):
	#var uppercase_name = item[0].to_upper() + item.substr(1,-1)
	#var manager_name = uppercase_name + "Controller"
	#var controller = get_node(manager_name)
	if item == current_hat:
		current_hat = ""
	else:
		current_hat = item
	#if manager_name == current_hat_controller.name && manager_name:
		#current_hat_controller.Unequip()
	#elif controller != null:
		#current_hat_controller.Unequip()
		#controller.Equip()
		#current_hat_controller = controller
	#else:
		#push_warning(controller + " doesnt exists")
		#return
	item_equip.emit()
