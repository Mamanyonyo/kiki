extends Node2D

@export var damage = 5

func _on_area_2d_body_entered(player: Player) -> void:
	player.health_component.damage(damage)
	queue_free()
