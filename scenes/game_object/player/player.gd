class_name Player extends CharacterBody2D

const ACCELERATION_SMOOTHING = 25

@export var health_component: HealthComponent

@export var middle: Marker2D

@export var stats_component: StatsComponent
@onready var inventory_component : InventoryComponent = $InventoryComponent
@onready var stamina_component : StaminaComponent = $StaminaComponent
@onready var mana_component : ManaComponent = $ManaComponent
@onready var sprite_manager : SpriteManager = $SpriteManager

var attacking = false
var can_move = true
var interacting = false

signal did_damage(amount: int)

#TODO Crear componente de movimiento player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.emit_player_ready()
	DialogueManager.dialogue_ended.connect(on_dialogue_end)
	
	
func _process(delta: float) -> void:
	var target_velocity = sprite_manager.direction * stats_component.speed
	velocity = velocity.lerp(target_velocity, 1 - exp(-get_physics_process_delta_time() * ACCELERATION_SMOOTHING))
	move_and_slide()
	
func _unhandled_input(event):
	if can_move:
		var movement_vector = get_movement_vector()
		sprite_manager.direction = movement_vector.normalized()
		sprite_manager.absolute_dir = Vector2(ceil(sprite_manager.direction.x), ceil(sprite_manager.direction.y))
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

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)

func _on_health_component_died():
	var tree = get_tree().get_first_node_in_group("tree")
	if GameEvents.tree && tree:
		stats_component.health = stats_component.max_health / 2
		health_component.changed.emit()
		global_position = tree.global_position + Vector2.DOWN * 30
	else: 
		get_tree().change_scene_to_file("res://scenes/title.tscn")

func _on_drive_component_drive_finish():
	sprite_manager.set_default_animations_and_sprites()     

func on_dialogue_end(_dialogue):
	can_move = true
