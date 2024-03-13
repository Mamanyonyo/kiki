extends Node

var door_amount = 0
var correct_toilets = 0
var toilet_complete = false

signal experience_vial_collected(exp: float)
signal money_collected(money: int)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal try_door_open(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal open_door(id: int)
signal toilet_puzzle_fail
signal toilet_puzzle_complete


func emit_money_collected(money: int):
	money_collected.emit(money)

func emit_experience_vial_collected(exp: float):
	experience_vial_collected.emit(exp)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)

func emit_try_door_open(id: int, price: int):
	try_door_open.emit(id, price)

func emit_open_door(id: int):
	open_door.emit(id)
	
func emit_toilet_puzzle_fail():
	toilet_puzzle_fail.emit()
	
func emit_toilet_puzzle_complete():
	toilet_puzzle_complete.emit()
