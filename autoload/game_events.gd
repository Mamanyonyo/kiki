extends Node

var door_amount = 0
var correct_toilets = 0
var toilet_complete = false
var tree = true
var wave_in_course = false
var wave_limit = false
var wave = 0

signal experience_vial_collected(exp: float)
signal money_collected(money: int)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal try_door_open(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal open_door(id: int)
signal toilet_puzzle_fail
signal toilet_puzzle_complete
signal tree_destroyed
signal wave_start(wave: int)
signal wave_end(wave: int)
signal new_spawner(spawner: EnemySpawner)
signal enemy_died(wave_spawned: bool)
signal wave_enemy_spawned
signal wave_enemy_limit_reached

func emit_new_spawner(spawner):
	new_spawner.emit(spawner)

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

func emit_tree_destroyed():
	tree_destroyed.emit()

func emit_wave_start():
	wave_start.emit(wave)
	
func emit_wave_end():
	wave_end.emit(wave)

func emit_enemy_died(wave_spawned: bool):
	enemy_died.emit(wave_spawned)

func emit_wave_enemy_limit_reached():
	wave_enemy_limit_reached.emit()
