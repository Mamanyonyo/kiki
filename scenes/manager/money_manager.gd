extends Node

@export var money = 0

signal money_updated(new: int)

func _ready():
	var game_events = GameEvents
	game_events.try_door_open.connect(on_open_door)
	game_events.money_collected.connect(on_money_collected)
	money_updated.emit(money)
	
func try_buy(price):
	if money < price: return false
	money -= price
	money_updated.emit(money)
	return true

func on_open_door(id, price):
	if try_buy(price): GameEvents.emit_open_door(id)

func on_money_collected(amount):
	money += amount
	money_updated.emit(money)
