extends EquipmentController

var recharging = false
@onready var timer = $Timer

func spell_casted():
	timer.start()
	recharging = true

func _on_timer_timeout() -> void:
	recharging = false
