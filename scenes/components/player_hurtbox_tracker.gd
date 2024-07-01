extends Area2D

@export var sprite_manager : SpriteManager
@export var parent : Node2D
@export var stats_component : StatsComponent

@export var animation_prefix : String

var in_range = false

func _process(_delta):
	if in_range && !parent.attacking:
		parent.attacking = true
		sprite_manager.animator.play(animation_prefix + "_" + sprite_manager.facing_str)
		##WARNING no se si esto deberia ir aca
		sprite_manager.melee_hitbox.damage = stats_component.damage

func _on_area_entered(area: Area2D) -> void:
	in_range = true

func _on_area_exited(area: Area2D) -> void:
	in_range = false
