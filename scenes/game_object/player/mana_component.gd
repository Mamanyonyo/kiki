class_name ManaComponent extends Node

@export var stats_component : StatsComponent
@export var hat_manager : HatManager
@onready var restore_timer = $RestoreTimer

signal mana_changed

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
	mana_changed.emit()
	return true

func get_health_percent():
	if stats_component.mana <= 0: return 0
	var division : float = stats_component.mana/stats_component.max_mana
	return division

func _on_restore_timer_timeout() -> void:
	stats_component.mana += stats_component.mana_reg
	if stats_component.mana >= stats_component.max_mana:
		stats_component.mana = stats_component.max_mana
		restore_timer.stop()
	mana_changed.emit()
