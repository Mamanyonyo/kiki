class_name ManaComponent extends QuantifiableStatComponent

@export var hat_manager : HatManager
@onready var restore_timer = $RestoreTimer


func _process(_delta):
	if stats_component.mana < stats_component.max_mana:
		restore_timer.paused = false
		if restore_timer.is_stopped(): restore_timer.start()

func cast_and_check(cost):
	if hat_manager != null && hat_manager.current_controller != null && hat_manager.current_controller.item_id == "ghost_doll" && !hat_manager.current_controller.recharging:
		hat_manager.current_controller.spell_casted()
		return true
	if stats_component.mana - cost < 0: return false
	stats_component.mana -= cost
	changed.emit()
	return true

func _on_restore_timer_timeout() -> void:
	stats_component.mana += stats_component.mana_reg
	if stats_component.mana >= stats_component.max_mana:
		stats_component.mana = stats_component.max_mana
		restore_timer.stop()
	changed.emit()
