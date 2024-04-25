extends Area2D

@export var sprite_manager : SpriteManager
@export var parent : Node2D

@export var animation_prefix : String


func _on_area_entered(area: Area2D) -> void:
	parent.attacking = true
	sprite_manager.animator.play(animation_prefix + "_" + sprite_manager.facing_str)
