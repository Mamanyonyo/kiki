class_name BasicEnemy extends CharacterBody2D

@export var wave_spawned : bool = false
@export var detection_range : float = 100

@export var health_component: HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var state_machine: StateMachine = $BasicEnemyStateMachine

var attacking = false
var can_move = true

func _ready():
	pass

func _on_health_component_died():
	GameEvents.emit_enemy_died(wave_spawned)
	queue_free()
