class_name Player extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

@export var health_component: HealthComponent
@export var damage_timer: Timer
@export var movement_animator: AnimationPlayer
@export var sprite: Sprite2D

@export var hp_bar: ProgressBar

@export var hitbox: Area2D

var colliding_bodies = 0
var previous_dir = Vector2.ZERO
var attacking = false
var facing_str = "down"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_health_display()
	sprite.frame_coords.x = 0
	sprite.frame_coords.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var absolute_dir = Vector2(ceil(direction.x), ceil(direction.y))
	if !attacking:
		match absolute_dir:
			Vector2(0, -1): 
				movement_animator.play("walk_up")
				facing_str = "up"
				sprite.scale.x = 1
			Vector2(0, 1): 
				movement_animator.play("walk_down")
				facing_str = "down"
				sprite.scale.x = 1
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
	
	previous_dir = absolute_dir
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()
	

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)

func _on_area_2d_area_entered(area):
	health_component.damage(5)

func check_deal_damage():
	if colliding_bodies == 0 || !damage_timer.is_stopped(): return
	health_component.damage(1)
	damage_timer.start()
	
func get_rotation_in_degrees():
	match facing_str:
		"up":
			return 270
		"down":
			return 90
		_: 
			if(sprite.scale.x == -1): return 180
			return 0
			
		

func update_health_display():
	hp_bar.value = health_component.get_health_percent()
	
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
		hitbox.monitorable = false
		correct_sprite_on_facing_str()

func _on_collision_area_2d_body_entered(body: Node2D) -> void:
	colliding_bodies += 1
	check_deal_damage()

func _on_collision_area_2d_body_exited(body: Node2D) -> void:
	colliding_bodies -= 1

func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()

func _on_health_component_health_changed() -> void:
	update_health_display()
