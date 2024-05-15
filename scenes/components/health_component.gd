extends QuantifiableStatComponent
class_name HealthComponent

signal died

var floating_text_scene: PackedScene = preload("res://scenes/UI/floating_text.tscn")

func damage(incoming_damage: float):
	
	var final_damage = incoming_damage - stats_component.resistance
	if final_damage < 0: final_damage = 0
	stats_component.health -= final_damage
	changed.emit()
	if !get_parent().is_in_group("Ally"):
		GameEvents.emit_enemy_hit(get_parent())
		if final_damage > 0:
			var floating_text = floating_text_scene.instantiate() as Node2D
			get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
			floating_text.global_position = get_parent().global_position
			floating_text.start(str(final_damage))
	check_death()
	
func check_death():
	if stats_component.health <= 0: death()
	
func set_hp(new_hp: float):
	stats_component.health = new_hp
	changed.emit()

func death():
	died.emit()
