class_name SpellUI extends Label

var spell
var spell_id

func set_spell(new_spell_id):
	spell_id = new_spell_id
	spell = DataImport.skill_data[new_spell_id]
	text = spell.name

func _on_gui_input(event: InputEvent) -> void:
	if(event.is_pressed()):
		var weapon_manager = get_tree().get_first_node_in_group("Player").get_node("WeaponManager") as WeaponManager
		var current_weapon = weapon_manager.current_weapon_controller as MagicWeaponController
		current_weapon.try_spell_cast(spell_id)
