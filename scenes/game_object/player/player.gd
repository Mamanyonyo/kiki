class_name Player extends CharacterBody2D

const ACCELERATION_SMOOTHING = 25

@export var health_component: HealthComponent

@export var middle: Marker2D

@export var stats_component: StatsComponent
@onready var inventory_component : InventoryComponent = $InventoryComponent
@onready var stamina_component : StaminaComponent = $StaminaComponent
@onready var sprite_manager : SpriteManager = $SpriteManager

var attacking = false
var can_move = true

signal did_damage(amount: int)

#TODO Crear componente de movimiento player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.emit_player_ready()
	
	
func _process(delta: float) -> void:
	var target_velocity = sprite_manager.direction * stats_component.speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-get_physics_process_delta_time() * ACCELERATION_SMOOTHING))
	move_and_slide()
	
func _unhandled_input(event):
	if can_move:
		var movement_vector = get_movement_vector()
		sprite_manager.direction = movement_vector.normalized()
		sprite_manager.absolute_dir = Vector2(ceil(sprite_manager.direction.x), ceil(sprite_manager.direction.y))
		check_interaction()
		check_run()
		
		
func check_run():
	if Input.is_action_just_pressed("run"):
		stamina_component.running = true
		if stamina_component.can_run(): stats_component.speed += stats_component.max_speed * 25 / 100
		else: stats_component.speed = stats_component.max_speed
	elif Input.is_action_pressed("run"):
		if !stamina_component.can_run(): 
			stats_component.speed = stats_component.max_speed
			stamina_component.running = false
	elif Input.is_action_just_released("run"):
		stats_component.speed = stats_component.max_speed
		stamina_component.running = false

func check_interaction():
	if Input.is_action_just_pressed("attack"):
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(middle.global_position, middle.global_position + sprite_manager.get_facing_direction() * 20)
		query.collision_mask = 0x80
		var result = space_state.intersect_ray(query)
		if result != { }:
			if result.collider.has_method("on_interact"):
				result.collider.on_interact()

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)

func _on_area_2d_area_entered(area):
	health_component.damage(5)

func _on_health_component_died():
	if GameEvents.tree:
		stats_component.health = stats_component.max_health / 2
		health_component.changed.emit()
		global_position = get_tree().get_first_node_in_group("tree").global_position + Vector2.DOWN * 30
	else: queue_free()

func _on_drive_component_drive_finish():
	sprite_manager.set_default_animations_and_sprites()     
