extends Node
class_name HealthComponent

signal died

@export var max_health: float = 20
var health

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health

func damage(incoming_damage: float):
	health -= incoming_damage
	Callable(check_death).call_deferred()
	
func check_death():
	if health <= 0: death()

func death():
	died.emit()
	owner.queue_free()
