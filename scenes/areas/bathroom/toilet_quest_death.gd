extends Node

var parent : Node2D

func _ready():
	GameEvents.toilet_killed_quest_total += 1
	parent = get_parent()
	
	parent.ready.connect(on_ready)
	
	
func on_ready():
	var health_comp : HealthComponent = parent.get_node("HealthComponent")
	health_comp.died.connect(on_death)
	
func on_death():
	GameEvents.toilet_killed_quest += 1
