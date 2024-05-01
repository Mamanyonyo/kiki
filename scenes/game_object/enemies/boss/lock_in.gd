extends State

@export var orb : GirlCultBossOrb
@export var distance_from_player = 48
@export var starting_direction = Vector2.RIGHT
@onready var shooting_interval = $Timer
@export var projectile : PackedScene
@export var bullet_damage = 4

func Enter():
	shooting_interval.start()

func Update(_delta):
	var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
	var i = 0
	var this_orb_index : float
	for current_orb : GirlCultBossOrb in orbs:
		if current_orb.get_rid() == orb.get_rid(): this_orb_index = i
		i += 1
	var player = get_tree().get_first_node_in_group("Player") as Player
	var angle_degrees = this_orb_index * 90
	var angle = deg_to_rad(angle_degrees)
	var rotation_vector = starting_direction.rotated(angle) as Vector2
	orb.global_position = player.global_position + rotation_vector * 48
	if shooting_interval.is_stopped():
		var bullet_rotation = deg_to_rad(angle_degrees + 180)
		var bullet_instance = projectile.instantiate() as HitboxComponent
		bullet_instance.set_collision_layer_value(pow(2, 3-1), false)
		bullet_instance.set_collision_layer_value(pow(2, 9-1), true)
		bullet_instance.set_collision_mask_value(pow(2, 1-1), false)
		bullet_instance.rotation = bullet_rotation
		bullet_instance.damage = bullet_damage
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		entities_layer.add_child(bullet_instance)
		bullet_instance.global_position = orb.global_position
		shooting_interval.start()
	
func Exit():
	shooting_interval.stop()
