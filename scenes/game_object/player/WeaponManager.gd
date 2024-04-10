class_name WeaponManager extends Node

@export var player : CharacterBody2D
@export var current_weapon_controller : MagicWeaponController
@export var default_controller : MagicWeaponController

signal controller_item_equip

func _ready():
	#TODO no handlear esto por game events caso de querer darle inventario a alguien mas
	GameEvents.item_equip.connect(on_item_equip)

func _unhandled_input(event: InputEvent) -> void:
	current_weapon_controller.Inputs()

func equip_item(item: String):
	var uppercase_name = item[0].to_upper() + item.substr(1,-1)
	var manager_name = uppercase_name + "Controller"
	var controller = get_node(manager_name)
	if manager_name == current_weapon_controller.name && manager_name != default_controller.name:
		current_weapon_controller.Unequip()
		current_weapon_controller = default_controller
	elif controller != null:
		current_weapon_controller.Unequip()
		controller.Equip()
		current_weapon_controller = controller
	controller_item_equip.emit()

func on_item_equip(item: String):
	equip_item(item)
