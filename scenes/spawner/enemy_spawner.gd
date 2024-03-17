class_name EnemySpawner extends Node2D

@export var enemy_scene: PackedScene
@export var active = false
@export var timer : Timer

func _ready():
	GameEvents.emit_new_spawner(self)
	
func disable():
	timer.autostart = false
	active = false
	timer.stop()
	
func enable():
	timer.autostart = true
	active = true
	timer.start()

func _on_timer_timeout() -> void:
	var enemy_instance = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy_instance)
	enemy_instance.global_position = global_position
	enemy_instance.get_node("VelocityComponent").original_position = global_position
	enemy_instance.wave_spawned = true
