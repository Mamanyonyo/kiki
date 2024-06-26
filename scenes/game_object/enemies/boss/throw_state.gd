extends State

@export var extra_distance : float = 32
@export var orb : GirlCultBossOrb
@export var speed_boost = 400
@export var stats_component : StatsComponent
@export var velocity_component : VelocityComponent

var target_pos : Vector2
var target_dir : Vector2
func _ready():
	orb.initialized.connect(on_init)

func Enter():
	stats_component.speed += speed_boost
	var player = get_tree().get_first_node_in_group("Player") as Player
	target_pos = player.global_position + orb.global_position.direction_to(player.global_position) * extra_distance
	target_dir = orb.global_position.direction_to(target_pos)

func Update(delta):
	if orb.global_position.distance_to(target_pos) <= 10: 
		transitioned.emit("ReturnToGirl")
		return
	orb.global_position += target_dir * delta * stats_component.speed

func Exit():
	stats_component.speed = stats_component.max_speed
	
func on_init():
	orb.girl.state_machine.new_state_entered.connect(on_new_girl_state)


func on_new_girl_state(new_state_name):
	if new_state_name == "Throwing": transitioned.emit(name)
