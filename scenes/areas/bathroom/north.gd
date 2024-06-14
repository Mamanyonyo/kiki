extends Area

@export var opacity = 0
@export var time_to_zero = 1
@export var time_to_reset_from_zero = 1
@onready var timer = $Timer

func Enter():
	super()
	timer.start()

func Leave():
	super()
	timer.stop()

func _on_timer_timeout() -> void:
	on_and_off()

func on_and_off():
	var modulate : MainModulate = get_tree().get_first_node_in_group("modulate")
	modulate.change_and_reset(opacity, time_to_zero, time_to_reset_from_zero)
