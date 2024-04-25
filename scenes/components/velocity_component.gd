class_name VelocityComponent extends Node

@export var acceleration: float = 5
@export var stats_component: StatsComponent
@export var navigation_agent : NavigationAgent2D

var original_position

var velocity = Vector2.ZERO

func _ready():
	var owner_node2d = owner as Node2D
	if original_position == null: original_position = owner_node2d.global_position

func accelerate_to_objective():
	var owner_node2d = owner as Node2D
	if owner_node2d == null: return
	##TODO en el futuro, reescribir esto de la forma en que se use el movimiento de siempre para chasear,
	##pero cuando se este colisionando con el terreno, se haga pathfinding
	var direction = owner_node2d.to_local(navigation_agent.get_next_path_position()).normalized()
	accelerate_in_direction(direction)
	move(owner_node2d)

func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * stats_component.speed
	var lerped_velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	velocity = lerped_velocity

func move(character_body: CharacterBody2D):
	if !get_parent().can_move: return
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity

func make_path(objective_str):
	var objective = get_tree().get_first_node_in_group(objective_str) as Node2D
	if objective == null:
		return
	navigation_agent.target_position = objective.global_position
	
func make_path_to_pos(pos: Vector2):
	navigation_agent.target_position = pos

#
#func _on_timer_timeout() -> void:
	#make_path("player")
