extends ProgressBar

@export var health_component : HealthComponent
@export var sprite_component : SpriteManager

func _ready():
	health_component.changed.connect(on_health_component_change)
	update_health_display()
	
func update_health_display():
	value = health_component.get_percent()

func on_health_component_change():
	update_health_display()




func _on_sprite_manager_changed_facing_direction() -> void:
	if sprite_component.absolute_dir.x == -1: scale.x = -1
	else: scale.x = 1
