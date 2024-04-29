extends State

@export var velocity_component : VelocityComponent
@export var orb : GirlCultBossOrb

var objective_position : Vector2

##TODO mover la siguiente orbe si se llegase a morir
##TODO Arreglar wall stuck

func Enter():
	var player = get_tree().get_first_node_in_group("Player")
	objective_position = player.global_position
	velocity_component.make_path_to_pos(objective_position)

func Update(_delta):
	velocity_component.accelerate_to_objective()
	if orb.global_position.distance_to(objective_position) <= 2:
		transitioned.emit("ShootLaserAtPlayer")
		return
