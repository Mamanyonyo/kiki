extends State

@export var sprite_manager : SpriteManager
@export var velocity_component : VelocityComponent
@export var girl : UnnamedCultGirlBoss

var returned = 0

func _ready():
	girl.orbs_loaded.connect(on_orbs_loaded)

func Enter():
	sprite_manager.sprite_side = 20
	sprite_manager.sprite_up = 21
	sprite_manager.sprite_down = 19
	sprite_manager.absolute_dir = Vector2.ZERO
	sprite_manager.correct_sprite_on_facing_str()

func Exit():
	sprite_manager.set_default_sprites()
	returned = 0

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
