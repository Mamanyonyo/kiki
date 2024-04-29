extends State

@export var girl : UnnamedCultGirlBoss
@export var sprite_manager : SpriteManager

func Enter():
	sprite_manager.sprite_side = 22
	sprite_manager.sprite_up = 23
	sprite_manager.sprite_down = 24
	sprite_manager.absolute_dir = Vector2.ZERO
	sprite_manager.correct_sprite_on_facing_str()
	var first_orb = get_tree().get_first_node_in_group("yellow_orb_boss") as GirlCultBossOrb
	first_orb.state_machine.on_child_transition("GoToPlayerPos")
	
func Update(_delta):
	var current_total_hp = girl.stats_component.health
	for orb in girl.current_orbs:
		if orb != null:
			current_total_hp += orb.stats_component.health
	var percentage = (current_total_hp * 100)/girl.boss_and_all_orbs_max_hp_sum
	if percentage < 50:
		transitioned.emit("ChasePlayer")

func Exit():
	var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
	for orb : GirlCultBossOrb in orbs:
		orb.state_machine.on_child_transition("ReturnToGirl")
	sprite_manager.set_default_sprites()
