class_name QuantifiableStatComponent extends Node

signal changed

@export var stats_component : StatsComponent
@export var stat_name : String

func _ready():
	changed.emit()
	
func get_percent():
	if stats_component["max_"+stat_name] <= 0: return 0
	var division : float = stats_component[stat_name]/stats_component["max_"+stat_name]
	return division
	
func set_stat(new):
	stats_component[stat_name] = new
	changed.emit()
	
func set_max(new):
	stats_component["max_"+stat_name] = new
	changed.emit()

func set_stat_to_max():
	stats_component[stat_name] = stats_component["max_"+stat_name]
	changed.emit()
