class_name StaminaComponent extends Node

@export var stats_component : StatsComponent
@onready var timer = $DrainTimer
@onready var restore_timer = $RestoreTimer

var running = false
var was_running = false

signal stamina_changed

func _process(_delta):
	if running:
		if !was_running: _on_timer_timeout()
		was_running = true
		restore_timer.paused = true
		var parent = get_parent()
		if parent.previous_position == parent.global_position: 
			timer.paused = true
			return
		timer.paused = false
		if timer.is_stopped(): timer.start()
	else:
		was_running = false
		timer.stop()
		if stats_component.stamina < stats_component.max_stamina:
			restore_timer.paused = false
			if restore_timer.is_stopped(): restore_timer.start()

func get_health_percent():
	if stats_component.stamina <= 0: return 0
	var division : float = stats_component.stamina/stats_component.max_stamina
	return division

func can_run():
	return get_health_percent() > 0

func _on_timer_timeout() -> void:
	stats_component.stamina -= 5
	if stats_component.stamina < 0: stats_component.stamina = 0
	stamina_changed.emit()

func _on_restore_timer_timeout() -> void:
	stats_component.stamina += 5
	if stats_component.stamina >= stats_component.max_stamina:
		stats_component.stamina = stats_component.max_stamina
		restore_timer.stop()
	stamina_changed.emit()
