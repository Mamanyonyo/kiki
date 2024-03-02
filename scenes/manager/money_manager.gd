extends Node

@export var money = 0

func _ready():
	var game_events = GameEvents
	game_events.try_door_open.connect(open_door)
	
func try_buy(price):
	if money < price: return false
	money -= price
	return true

func open_door(id, price):
	if try_buy(price): GameEvents.emit_open_door(id)
