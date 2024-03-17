extends ProgressBar

@export var health_component : HealthComponent

func _ready():
	health_component.health_changed.connect(on_health_component_change)
	update_health_display()
	
func update_health_display():
	value = health_component.get_health_percent()

func on_health_component_change():
	update_health_display()


