extends Node

signal experience_vial_collected(exp: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

# Called when the node enters the scene tree for the first time.
func emit_experience_vial_collected(exp: float):
	experience_vial_collected.emit(exp)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)
