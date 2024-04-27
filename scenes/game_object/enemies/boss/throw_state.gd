extends State

@export var extra_distance : float = 10
@export var orb : GirlCultBossOrb
@export var speed_boost = 400
@export var stats_component : StatsComponent
@export var velocity_component : VelocityComponent

var target_pos : Vector2
#var target_dir : Vector2

var returning = false

func _ready():
	orb.initialized.connect(on_init)

func Enter():
	stats_component.speed += speed_boost
	var player = get_tree().get_first_node_in_group("Player") as Player
	target_pos = player.global_position + orb.global_position.direction_to(player.global_position) * extra_distance
	#target_dir = target_pos.normalized()
	velocity_component.make_path_to_pos(target_pos)

func Update(delta):
	##TODO hacer que mientras se lance por los primeros segundos recalcule la direccion al player
	if !returning:
		if orb.global_position.distance_to(target_pos) <= 10: returning = true
	else: 
		velocity_component.make_path_to_pos(orb.girl.global_position)
		if orb.global_position.distance_to(orb.girl.global_position) <= 5:
			transitioned.emit("Spin")
	velocity_component.accelerate_to_objective()
	

func Exit():
	stats_component.speed = stats_component.max_speed
	returning = false
	
func on_init():
	orb.girl.state_machine.new_state_entered.connect(on_new_girl_state)


func on_new_girl_state(new_state_name):
	if new_state_name == "Throwing": transitioned.emit(name)
