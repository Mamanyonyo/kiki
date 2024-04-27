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
	for orb in girl.current_orbs:
		orb.state_machine.new_state_entered.connect(on_orb_changed_state)

##TODO cuidado porque si no se revisa el estado despues de que muera una orbe se puede quedar aca por siempre

func on_orb_changed_state(new_orb_state_name):
	if girl.state_machine.current_state != self || new_orb_state_name != "Spin": return
	returned += 1
	if returned >= get_tree().get_nodes_in_group("yellow_orb_boss").size():
		transitioned.emit("ChasePlayer")
