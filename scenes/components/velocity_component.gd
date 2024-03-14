class_name VelocityComponent extends Node

@export var acceleration: float = 5
@export var stats_component: StatsComponent
@export var navigation_agent : NavigationAgent2D

var velocity = Vector2.ZERO

func accelerate_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null: return
	##en el futuro, reescribir esto de la forma en que se use el movimiento de siempre para chasear,
	##pero cuando se este colisionando con el terreno, se haga pathfinding
	var direction = get_parent().to_local(navigation_agent.get_next_path_position()).normalized()
	accelerate_in_direction(direction)

func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * stats_component.speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))

func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity

func make_path():
	var player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	if player == null:
		return
	navigation_agent.target_position = player.global_position


func _on_timer_timeout() -> void:
	make_path()
