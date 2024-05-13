class_name WaveManager extends Node

@onready var timer = $Timer

@export var wave_enemies = 20
var remaining
var spawned = 0

func _ready():
	GameEvents.enemy_died.connect(on_enemy_died)
	GameEvents.wave_enemy_spawned.connect(on_wave_enemy_spawned)
	timer.start()

func get_remaining_time():
	return timer.time_left

func wave_start():
	GameEvents.wave_limit = false
	spawned = 0
	remaining = wave_enemies
	GameEvents.wave += 1
	GameEvents.emit_wave_start()
	GameEvents.wave_in_course = true
	
func wave_end():
	GameEvents.emit_wave_end()
	timer.start()

func _on_timer_timeout():
	timer.stop()
	wave_start()

func on_enemy_died(wave_spawned: bool):
	if wave_spawned:
		remaining -= 1
		if remaining <= 0:
			wave_end()
			
func on_wave_enemy_spawned():
	spawned += 1
	if spawned >= wave_enemies:
		GameEvents.emit_wave_enemy_limit_reached()
		GameEvents.wave_limit = true
