extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@export var name_label: Label
@export var description_label: Label
@export var animation: AnimationPlayer
@export var hover_animator: AnimationPlayer

var disabled = false

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	
func play_in(delay):
	visible = false
	await get_tree().create_timer(delay).timeout
	animation.play("in")

func play_discard():
	animation.play("discard")
	
func select_card():
	disabled = true
	animation.play("selected")
	for other_card:AbilityUpgradeCard in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card != self: other_card.play_discard()
	
	await animation.animation_finished
	selected.emit()


func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click") && !disabled: select_card()

func _on_mouse_entered() -> void:
	if !disabled: hover_animator.play("hover")
