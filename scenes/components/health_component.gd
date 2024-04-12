extends QuantifiableStatComponent
class_name HealthComponent

signal died

func damage(incoming_damage: float):
	var final_damage = incoming_damage - stats_component.resistance
	if final_damage < 0: final_damage = 0
	stats_component.health -= final_damage
	changed.emit()
	Callable(check_death).call_deferred()
	
func check_death():
	if stats_component.health <= 0: death()
	
func set_hp(new_hp: float):
	stats_component.health = new_hp
	changed.emit()

func death():
	died.emit()
