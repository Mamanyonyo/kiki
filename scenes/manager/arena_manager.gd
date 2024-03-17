extends Node

@onready var timer = $Timer

var wave = 0
var wave_enemies = 20
var remaining

func _ready():
	GameEvents.enemy_died.connect(on_enemy_died)
	timer.start()

func get_remaining_time():
	return timer.time_left

func wave_start():
	remaining = wave_enemies
	wave += 1
	GameEvents.emit_wave_start(wave)
	GameEvents.wave_in_course = true
	
func wave_end():
	GameEvents.emit_wave_end(wave)
	timer.start()

func _on_timer_timeout():
	timer.stop()
	wave_enemies = remaining

func on_enemy_died(wave_spawned: bool):
	if wave_spawned:
		remaining -= 1
		if remaining <= 0:
			wave_end()
