extends State

@export var velocity_component : VelocityComponent
@export var stats_component : StatsComponent
@export var orb : GirlCultBossOrb
@export var speed_boost : float = 500

func Enter():
	stats_component.speed += speed_boost

func Update(_delta):
	velocity_component.make_path_to_pos(orb.girl.global_position)
	if orb.global_position.distance_to(orb.girl.global_position) <= 5:
			transitioned.emit("Spin")
	velocity_component.accelerate_to_objective()

func Exit():
	stats_component.speed -= speed_boost
