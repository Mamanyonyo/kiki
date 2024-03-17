extends ChasePlayer

@export var stats : StatsComponent
@export var health_component : HealthComponent
@export var percentage_to_activate_attack : float = 0.25
@export var shape : CollisionShape2D

@export var sprite : Sprite2D

var current_percentage_to_activate_attack

func _ready():
	current_percentage_to_activate_attack = 1 - percentage_to_activate_attack
	
func Enter():
	shape.set_deferred("disabled", true)
	sprite.frame_coords.y = 0
	sprite.frame_coords.x = 0
	sprite.rotation_degrees = 0
	sprite.rotation = 0
	sprite.position.y = -16

func Update(_delta):
	if health_component.get_health_percent() < current_percentage_to_activate_attack:
		current_percentage_to_activate_attack = current_percentage_to_activate_attack - percentage_to_activate_attack
		transitioned.emit("ChaseClosestToilet")
		return
	super.Update(_delta)
	

	#if health_component.get_health_percent() < percentage_to_activate_attack && state == DEFAULT:
		#state = CHASING_CLOSEST_TOILET
		#percentage_to_activate_attack -= 0.25
		#get_closest_toilet()
		#
