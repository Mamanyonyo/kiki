extends quantifiable_drop

func collect():
	GameEvents.emit_money_collected(value)
	queue_free()
