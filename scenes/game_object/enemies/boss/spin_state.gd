extends State

@export var initial_angle : float

@export var girl : CharacterBody2D
@export var entity : BasicEnemy
@export var radius = 20
@export var speed = 5

@export var stats_component : StatsComponent

var d = 0.0

func Enter():
	d = deg_to_rad(initial_angle) / speed
	update_position()

func Update(delta):
	d += delta
	update_position()

func update_position():
	if !entity.can_move: return
	
	entity.global_position = Vector2(
		sin(d * speed) * radius,
		cos(d * speed) * radius
	) + girl.global_position
