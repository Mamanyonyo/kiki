class_name SpellUI extends Label

var spell
var spell_id

func set_spell(new_spell_id):
	spell_id = new_spell_id
	spell = DataImport.skill_data[new_spell_id]
	var key = InputMap.action_get_events(new_spell_id)[0].as_text()
	if key.find("(Physical)"): key = key.replace("(Physical)", "")
	var mana_cost = str(DataImport.skill_data[new_spell_id].cost)
	text = spell.name + " " + key + " " + mana_cost + "MP"

func _on_gui_input(event: InputEvent) -> void:
	if(event.is_pressed()):
		var weapon_manager = get_tree().get_first_node_in_group("Player").get_node("WeaponManager") as WeaponManager
		var current_weapon = weapon_manager.current_controller as MagicWeaponController
		current_weapon.try_spell_cast(spell_id)
