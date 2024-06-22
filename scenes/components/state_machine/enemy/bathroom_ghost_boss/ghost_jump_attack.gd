extends State

@export var boss : BathroomGhostBoss
@export var sprite : Sprite2D
@export var shape : CollisionShape2D
@export var collision_shape : CollisionShape2D
@export var velocity_component : VelocityComponent
@export var stats_component : StatsComponent

@export var jump_speed : float = 250
@export var bonus_damage : float = 3
@export var shape_attack_size = 12

var normal_shape_size
var objective_direction : Vector2

func _ready():
	normal_shape_size = collision_shape.shape.radius

func Enter():
	var player = get_tree().get_first_node_in_group("Player")
	var player_center = player.get_node("Sprite2D/Middle").global_position
	collision_shape.shape.radius = shape_attack_size
	stats_component.speed = jump_speed
	stats_component.damage += bonus_damage
	stats_component.resistance -= bonus_damage
	sprite.frame_coords.x = 0
	sprite.frame_coords.y = 1
	sprite.look_at(player_center)
	objective_direction = (player_center - boss.global_position).normalized()
	boss.change_tile_based_on_tilemap_pos(true)
	
func Update(_delta):
	boss.global_position += objective_direction * _delta * stats_component.speed

func Exit():
	boss.jumped += 1
	stats_component.speed = stats_component.max_speed
	stats_component.damage = stats_component.max_damage
	stats_component.resistance = stats_component.max_resistance
	collision_shape.shape.radius = normal_shape_size
