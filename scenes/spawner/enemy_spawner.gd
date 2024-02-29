extends Node2D

@export var enemy_scene: PackedScene = preload("res://scenes/enemies/basic_enemy/basic_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	var enemy_instance = enemy_scene.instantiate() as Node2D
	get_parent().add_child(enemy_instance)
	enemy_instance.global_position = global_position
