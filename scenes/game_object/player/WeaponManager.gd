class_name WeaponManager extends Node

@export var player : CharacterBody2D
@export var current_controller : EquipmentController
@export var default_controller : EquipmentController
@export var drive_component : DriveComponent
signal item_equip

func _ready():
	if default_controller != null:
		current_controller = default_controller
		
func _process(delta):
	if current_controller != null: current_controller.Process(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_controller != null: 
		current_controller.Inputs(event)

func equip_item(item: String):
	if default_controller != null:
		if current_controller.has_method("Drive_exit"): current_controller.Drive_exit()
		if current_controller.item_id == default_controller.item_id && item == default_controller.item_id: return
	var controller : EquipmentController
	for controller_node : EquipmentController in get_children():
		if controller_node.item_id == item: 
			controller = controller_node
		pass
	if current_controller != null && item == current_controller.item_id:
		current_controller.Unequip()
		current_controller = default_controller
	elif controller != null:
		if current_controller != null: current_controller.Unequip()
		controller.Equip()
		current_controller = controller
	else:
		push_warning(item + " does not have a controller")
		return
	item_equip.emit()


func _on_drive_component_drive_start():
	if current_controller.has_method("Drive_enter"): current_controller.Drive_enter()

func _on_drive_component_drive_finish():
	if current_controller.has_method("Drive_exit"): current_controller.Drive_exit()
