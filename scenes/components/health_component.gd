extends Node
class_name HealthComponent

signal died
signal health_changed

@export var stats_component : StatsComponent

func damage(incoming_damage: float):
	var final_damage = incoming_damage - stats_component.resistance
	if final_damage < 0: final_damage = 0
	stats_component.health -= final_damage
	health_changed.emit()
	Callable(check_death).call_deferred()
	
func check_death():
	if stats_component.health <= 0: death()
	
func get_health_percent():
	if stats_component.max_health <= 0: return 0
	var division : float = stats_component.health/stats_component.max_health
	return division
	
func set_hp(new_hp: float):
	stats_component.health = new_hp
	health_changed.emit()

func death():
	died.emit()
