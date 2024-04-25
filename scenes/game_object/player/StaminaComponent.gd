class_name StaminaComponent extends QuantifiableStatComponent

@onready var timer = $DrainTimer
@onready var restore_timer = $RestoreTimer
@export var sprite_manager : SpriteManager

var running = false
var was_running = false

func _process(_delta):
	if running:
		if !was_running: _on_timer_timeout()
		was_running = true
		restore_timer.paused = true
		var parent = get_parent()
		if sprite_manager.direction == parent.global_position: 
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

func can_run():
	return get_percent() > 0

func _on_timer_timeout() -> void:
	stats_component.stamina -= 5
	if stats_component.stamina < 0: stats_component.stamina = 0
	changed.emit()

func _on_restore_timer_timeout() -> void:
	stats_component.stamina += 5
	if stats_component.stamina >= stats_component.max_stamina:
		stats_component.stamina = stats_component.max_stamina
		restore_timer.stop()
	changed.emit()
