extends PanelContainer

signal selected

@export var name_label: Label
@export var description_label: Label

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"): selected.emit()
