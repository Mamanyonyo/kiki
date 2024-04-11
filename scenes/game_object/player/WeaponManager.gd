class_name WeaponManager extends Node

@export var player : CharacterBody2D
@export var current_weapon_controller : MagicWeaponController
@export var default_controller : MagicWeaponController
signal weapon_item_equip

func _unhandled_input(event: InputEvent) -> void:
	current_weapon_controller.Inputs()

func equip_item(item: String):
	var uppercase_name = item[0].to_upper() + item.substr(1,-1)
	var manager_name = uppercase_name + "Controller"
	var controller = get_node(manager_name)
	if current_weapon_controller.item_id == default_controller.item_id && item == default_controller.item_id: return
	elif manager_name == current_weapon_controller.name && manager_name != default_controller.name:
		current_weapon_controller.Unequip()
		current_weapon_controller = default_controller
	elif controller != null:
		current_weapon_controller.Unequip()
		controller.Equip()
		current_weapon_controller = controller
	weapon_item_equip.emit()
