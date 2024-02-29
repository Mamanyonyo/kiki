extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

func _on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent || health_component == null: return
	
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
