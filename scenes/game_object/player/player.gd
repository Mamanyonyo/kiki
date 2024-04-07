class_name Player extends CharacterBody2D

const ACCELERATION_SMOOTHING = 25

@export var health_component: HealthComponent
@export var movement_animator: AnimationPlayer
@export var sprite: Sprite2D

@export var book_hitbox: Area2D

@export var middle: Marker2D

@export var markers : Node2D

@export var stats_component: StatsComponent
@onready var inventory_component : InventoryComponent = $InventoryComponent
@onready var stamina_component : StaminaComponent = $StaminaComponent

var previous_dir = Vector2.ZERO
var previous_position : Vector2
var attacking = false
var can_move = true
var facing_str = "down"
var absolute_dir : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO

#TODO limpiar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_position = global_position
	sprite.frame_coords.x = 0
	sprite.frame_coords.y = 0
	inventory_component.add_item("book")
	book_hitbox.get_node("CollisionShape2D").set_deferred("disabled", true)


func _process(delta):
	if !attacking && can_move:
		match absolute_dir:
			Vector2(0, -1): 
				movement_animator.play("walk_up")
				facing_str = "up"
				sprite.scale.x = 1
				markers.scale.y = -1
			Vector2(0, 1): 
				movement_animator.play("walk_down")
				facing_str = "down"
				sprite.scale.x = 1
				markers.scale.y = 1
			Vector2.ZERO:
				match previous_dir:
						Vector2.ZERO: 
							movement_animator.stop(true)
						Vector2(0, -1): 
							sprite.frame_coords.x = 3
						Vector2(0, 1): sprite.frame_coords.x = 0
						_:
							sprite.frame_coords.x = 6
							if previous_dir.x == -1 : sprite.scale.x = -1
							else: sprite.scale.x = 1
			_:
				movement_animator.play("walk_side")
				if absolute_dir.x == -1: 
					sprite.scale.x = -1
				else: sprite.scale.x = 1
				facing_str = "side"
				markers.scale.y = 1
	
	previous_dir = absolute_dir
	var target_velocity = direction * stats_component.speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-get_physics_process_delta_time() * ACCELERATION_SMOOTHING))
	previous_position = global_position
	move_and_slide()
	
func _unhandled_input(event):
	if can_move:
		var movement_vector = get_movement_vector()
		direction = movement_vector.normalized()
		absolute_dir = Vector2(ceil(direction.x), ceil(direction.y))
		check_run()
		check_interaction()
	check_tp()
	
func check_tp():
	if Input.is_action_just_pressed("teleport"):
		global_position = get_global_mouse_position()
		
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
		var query = PhysicsRayQueryParameters2D.create(middle.global_position, middle.global_position + get_facing_direction() * 20)
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
	
func get_facing_direction():
	match facing_str:
		"up":
			return Vector2.UP
		"down":
			return Vector2.DOWN
		_: 
			if(sprite.scale.x == -1): return Vector2.LEFT
			return Vector2.RIGHT
	
func get_rotation_in_degrees():
	match facing_str:
		"up":
			return 270
		"down":
			return 90
		_: 
			if(sprite.scale.x == -1): return 180
			return 0
	
func correct_sprite_on_facing_str():
	sprite.frame_coords.y = 0
	match facing_str:
		"down": 
			sprite.frame_coords.x = 0
		"side":
			sprite.frame_coords.x = 6
		"up":
			sprite.frame_coords.x = 3

func _on_player_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		attacking = false
		book_hitbox.get_child(0).disabled = true
		correct_sprite_on_facing_str()

func _on_health_component_died():
	if GameEvents.tree:
		stats_component.health = stats_component.max_health / 2
		health_component.health_changed.emit()
		global_position = get_tree().get_first_node_in_group("tree").global_position + Vector2.DOWN * 30
	else: queue_free()
