class_name ItemManager extends Node

@export var spell_component : SpellsComponent


##TODO sacar scroll del invent
func learn_spell(spell_id : String):
	if !spell_component.items.has(spell_id): spell_component.add_item(spell_id)
