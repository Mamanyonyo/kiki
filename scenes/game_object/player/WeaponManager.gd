extends Node

@export var player : CharacterBody2D
@export var current_weapon_controller : WeaponController

func _ready():
	GameEvents.item_equip.connect(on_item_equip)

func _unhandled_input(event: InputEvent) -> void:
	current_weapon_controller.Inputs()

func on_item_equip(item: String):
	var manager_name = item[0].to_upper() + item.substr(1,-1) + "Controller"
	var controller = get_node(manager_name)
	if controller != null:
		current_weapon_controller.Unequip()
		controller.Equip()
		current_weapon_controller = controller
