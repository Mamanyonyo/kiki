extends Node

##TODO hacer que se pueda elegir libremente el stat e incrementos particularmente
@export var stats_component : StatsComponent
@export var default_waves = 1
@export var default_stat_increment = 2

var wave_manager : WaveManager

func _ready():
	GameEvents.wave_end.connect(on_wave_end)
	stats_component.ready.connect(on_stats_component_ready)

func on_stats_component_ready():
	var increments = floor(GameEvents.wave / default_waves)
	print(increments)
	var script_properties = stats_component.get_script().get_script_property_list()
	for prop in script_properties:
		if prop.type == 3:
			stats_component[prop.name] += increments * default_stat_increment

##TODO escalar al terminar wave
func on_wave_end():
	pass
