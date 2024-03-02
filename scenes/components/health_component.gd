extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 20
var health

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health

func damage(incoming_damage: float):
	health -= incoming_damage
	health_changed.emit()
	Callable(check_death).call_deferred()
	
func check_death():
	if health <= 0: death()
	
func get_health_percent():
	if max_health <= 0: return 0
	return health/max_health

func death():
	died.emit()
	owner.queue_free()
