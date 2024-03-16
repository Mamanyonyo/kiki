extends ChasePlayer

@export var stats : StatsComponent
@export var health_component : HealthComponent
@export var percentage_to_activate_attack : float = 0.25

var current_percentage_to_activate_attack

func _ready():
	current_percentage_to_activate_attack = 1 - percentage_to_activate_attack

func Update(_delta):
	if health_component.get_health_percent() < percentage_to_activate_attack:
		current_percentage_to_activate_attack = 1 - percentage_to_activate_attack
		transitioned.emit("ChaseClosestToilet")
		return
	super.Update(_delta)
	

	#if health_component.get_health_percent() < percentage_to_activate_attack && state == DEFAULT:
		#state = CHASING_CLOSEST_TOILET
		#percentage_to_activate_attack -= 0.25
		#get_closest_toilet()
		#
