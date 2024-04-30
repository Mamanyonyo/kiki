extends State

@export var velocity_component : VelocityComponent
@export var orb : GirlCultBossOrb
@export var health_component : HealthComponent

var objective_position : Vector2

##TODO mover la siguiente orbe si se llegase a morir
##TODO Arreglar wall stuck

func _ready():
	health_component.died.connect(on_death)

func Enter():
	var player = get_tree().get_first_node_in_group("Player")
	objective_position = player.global_position
	velocity_component.make_path_to_pos(objective_position)

func Update(_delta):
	velocity_component.accelerate_to_objective()
	if orb.global_position.distance_to(objective_position) <= 2:
		transitioned.emit("ShootLaserAtPlayer")
		return

func on_death():
	if orb.state_machine.current_state.name != name: return
	
	var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
	if orbs.size() == 1: orb.girl.state_machine.on_child_transition("ChasePlayer")
	var i = 0
	var this_orb_index : float
	for current_orb : GirlCultBossOrb in orbs:
		if current_orb.get_rid() == orb.get_rid(): this_orb_index = i
		i += 1
	var next_orb_index : float = this_orb_index + 1
	if next_orb_index >= orbs.size(): next_orb_index = 0
	var next_orb : GirlCultBossOrb = orbs[next_orb_index]
	next_orb.state_machine.on_child_transition("GoToPlayerPos")
