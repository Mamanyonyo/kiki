extends State

@export var girl : UnnamedCultGirlBoss
@export var sprite_manager : SpriteManager
@export var chase_state : UnnamedCultGirlBossChase

@export var tp_distance = 128

var returned = 0
var leaving = false

func _ready():
	girl.orbs_loaded.connect(on_orbs_loaded)

func Enter():
	sprite_manager.sprite_side = 23
	sprite_manager.sprite_up = 24
	sprite_manager.sprite_down = 22
	sprite_manager.absolute_dir = Vector2.ZERO
	sprite_manager.correct_sprite_on_facing_str()
	match chase_state.orb_state[chase_state.current_attack_index]:
		"LaserCage":
			var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
			for orb : GirlCultBossOrb in orbs:
				orb.state_machine.on_child_transition("LaserCage")
			var player = get_tree().get_first_node_in_group("Player")
			var player_pos = player.global_position
			var space_state = girl.get_world_2d().direct_space_state
			var RAYCAST_DISTANCE = 5000
			var directions = [Vector2.UP + Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]
			var farthest_hit = {
				"position": Vector2(0, 0),
				"distance": 0,
				"direction": Vector2.RIGHT
			}
			for direction in directions:
				var query = PhysicsRayQueryParameters2D.create(player.global_position, player.global_position + direction * RAYCAST_DISTANCE, pow(2, 1-1) + pow(2, 7-1))
				var result = space_state.intersect_ray(query)
				if result:
					var distance = player_pos.distance_to(result.position)
					if distance > farthest_hit.distance:
						farthest_hit = {
							"position": result.position,
							"distance": distance,
							"direction": direction
						}
			girl.global_position = player.global_position + farthest_hit.direction * tp_distance
			sprite_manager.look_at(player.global_position)
		"GoToPlayerPos":
			var first_orb = get_tree().get_first_node_in_group("yellow_orb_boss") as GirlCultBossOrb
			if !first_orb: return
			first_orb.state_machine.on_child_transition("GoToPlayerPos")
	
func Update(_delta):
	if leaving: 
		check_and_return_to_chase()
		return
	var current_total_hp = girl.stats_component.health
	for orb in girl.current_orbs:
		if orb != null:
			current_total_hp += orb.stats_component.health
	var percentage = (current_total_hp * 100)/girl.boss_and_all_orbs_max_hp_sum
	if percentage < chase_state.finish_thresholds[chase_state.current_attack_index]:
		leaving = true
		var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
		for orb : GirlCultBossOrb in orbs:
			orb.state_machine.on_child_transition("ReturnToGirl")

func Exit():
	chase_state.current_attack_index += 1
	sprite_manager.set_default_sprites()
	returned = 0
	leaving = false

func on_orbs_loaded():
	for orb : GirlCultBossOrb in girl.current_orbs:
		orb.state_machine.new_state_entered.connect(on_orb_changed_state)
		orb.health_component.died.connect(on_orb_death)

func on_orb_changed_state(new_orb_state_name):
	if girl.state_machine.current_state != self || new_orb_state_name != "Spin": return
	returned += 1
	check_and_return_to_chase()

func check_and_return_to_chase():
	if returned >= get_tree().get_nodes_in_group("yellow_orb_boss").size():
		transitioned.emit("ChasePlayer")

func on_orb_death():
	check_and_return_to_chase()
