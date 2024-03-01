extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
var floating_text_scene: PackedScene = preload("res://scenes/UI/floating_text.tscn")

func _on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent || health_component == null: return
	
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)

	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position
	floating_text.start(str(hitbox_component.damage))
