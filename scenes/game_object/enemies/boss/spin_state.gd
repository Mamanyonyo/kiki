extends State

@export var entity : GirlCultBossOrb
@export var radius = 20
@export var speed = 5

@export var stats_component : StatsComponent

var d = 0.0

func _ready():
	entity.initialized.connect(on_init)

func Enter():
	d = deg_to_rad(90 * entity.id) / speed
	update_position()

func Update(delta):
	d += delta
	update_position()

func update_position():
	if !entity.can_move: return
	
	entity.global_position = Vector2(
		sin(d * speed) * radius,
		cos(d * speed) * radius
	) + entity.girl.global_position

func on_init():
	entity.girl.state_machine.new_state_entered.connect(on_girl_changed_state)

func on_girl_changed_state(new_state):
	if entity.state_machine.current_state.name == name && new_state == "ChasePlayer":
		Enter()
