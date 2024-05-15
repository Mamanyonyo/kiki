extends Node

var toilet_killed_quest_total = 0
var toilet_killed_quest = 0
var toilet_killed_quest_finish = false

var last_obtained_item = ""
var door_amount = 0
var correct_toilets = 0
var toilet_complete = false
var tree = true
var wave_in_course = false
var wave_limit = false
var wave = 0
var debug = false

signal experience_vial_collected(exp: float)
signal money_collected(money: int)
signal try_door_open(id: int, price: int)
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
signal quantifiable_stat_changed(incoming_stat_name : String, current, max, percentage)
signal stat_update
signal enemy_hit(enemy)
signal item_equip(item_name: String)
signal show_cg(image_path)
signal stop_cg
signal player_ready(player: Player)
signal quest_finished(quest_id: String)
signal load_shop(name: String)
signal shop_open(shop: ShopComponent)

func emit_new_spawner(spawner):
	new_spawner.emit(spawner)

func emit_money_collected(money: int):
	money_collected.emit(money)

func emit_experience_vial_collected(exp: float):
	experience_vial_collected.emit(exp)

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

func emit_quantifiable_stat_changed(incoming_stat_name: String, current, max, percentage):
	quantifiable_stat_changed.emit(incoming_stat_name, current, max, percentage)

func emit_stat_update():
	stat_update.emit()

func emit_enemy_hit(enemy):
	enemy_hit.emit(enemy)

func emit_item_equip(item: String):
	item_equip.emit(item)
	
func emit_show_cg(path: String):
	show_cg.emit(path)

func emit_stop_cg():
	stop_cg.emit()

func emit_player_ready():
	player_ready.emit()

func emit_quest_finish(quest_id):
	quest_finished.emit(quest_id)

func emit_load_shop(name):
	load_shop.emit(name)

func emit_shop_open(shop_component):
	shop_open.emit(shop_component)
