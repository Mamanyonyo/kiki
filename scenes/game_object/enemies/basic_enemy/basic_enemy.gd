class_name BasicEnemy extends CharacterBody2D

@export var wave_spawned : bool = false
@export var detection_range : float = 100

@onready var health_component: HealthComponent = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var stats_component: StatsComponent = $StatsComponent

var can_move = true

func _on_health_component_died():
	GameEvents.emit_enemy_died(wave_spawned)
	queue_free()
