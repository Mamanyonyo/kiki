extends StaticBody2D

@onready var health_component = $HealthComponent
@onready var stats_components = $StatsComponent

func _ready():
	GameEvents.wave_end.connect(_on_wave_end)

func _on_health_component_died():
	GameEvents.tree = false
	GameEvents.emit_tree_destroyed()
	queue_free()

func _on_wave_end(_wave):
	health_component.set_hp(stats_components.max_health)
