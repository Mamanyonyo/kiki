class_name SpriteManager extends Node

@export var animator: AnimationPlayer
@export var sprite: Sprite2D

@export var gesture_animator : AnimationPlayer

@export var melee_hitbox: HitboxComponent

@export var sprite_side_default: float = 7
@export var sprite_down_default: float = 0
@export var sprite_up_default: float = 4

@export var default_walk_up_animation_name : String = "walk_up"
@export var default_walk_side_animation_name: String = "walk_side"
@export var default_walk_down_animation_name: String = "walk_down"

@export var markers : Node2D

var walk_up_animation_name : String
var walk_side_animation_name : String
var walk_down_animation_name : String

var sprite_side : float
var sprite_up : float
var sprite_down : float

var parent : CharacterBody2D

var previous_dir = Vector2.ZERO
var previous_position : Vector2
var facing_str = "down"
var absolute_dir : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO


signal changed_facing_direction


##TODO crear un animador distinto para los ataques melee

func _ready():
	set_default_animations_and_sprites()
	sprite.frame = sprite_down_default
	if melee_hitbox != null: 
		melee_hitbox.get_node("CollisionShape2D").set_deferred("disabled", true)
		melee_hitbox.scale = Vector2(1, 1)
	parent = get_parent()
	previous_position = parent.global_position
	animator.animation_finished.connect(_on_player_animator_animation_finished)
	
func _process(delta):
	if !parent.attacking && parent.can_move:
		if gesture_animator != null && gesture_animator.is_playing(): return
		match absolute_dir:
			Vector2(0, -1): 
				animator.play(walk_up_animation_name)
				facing_str = "up"
				sprite.scale.x = 1
				if markers != null: markers.scale.y = -1
				changed_facing_direction.emit()
			Vector2(0, 1): 
				animator.play(walk_down_animation_name)
				facing_str = "down"
				sprite.scale.x = 1
				if markers != null: markers.scale.y = 1
				changed_facing_direction.emit()
			Vector2.ZERO:
				match previous_dir:
						Vector2.ZERO:
							animator.stop(true)
							correct_sprite_on_facing_str()
						Vector2(0, -1): 
							sprite.frame = sprite_up
						Vector2(0, 1): 
							sprite.frame = sprite_down
						_:
							sprite.frame = sprite_side
							if previous_dir.x == -1 : sprite.scale.x = -1
							else: sprite.scale.x = 1
			_:
				animator.play(walk_side_animation_name)
				if absolute_dir.x == -1: 
					sprite.scale.x = -1
				else: sprite.scale.x = 1
				facing_str = "side"
				if markers != null: markers.scale.y = 1
				changed_facing_direction.emit()
				
	previous_position = parent.global_position
	previous_dir = absolute_dir

func get_facing_direction():
	match facing_str:
		"up":
			return Vector2.UP
		"down":
			return Vector2.DOWN
		_: 
			if(sprite.scale.x == -1): return Vector2.LEFT
			return Vector2.RIGHT
			
func correct_facing_str(dir):
	match dir:
		Vector2.DOWN: facing_str = "down"
		Vector2.UP: facing_str = "up"
		Vector2.LEFT: facing_str = "side"
		Vector2.RIGHT: facing_str = "side"
	
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
			sprite.frame = sprite_down
		"side":
			sprite.frame = sprite_side
		"up":
			sprite.frame = sprite_up
			
func set_default_animations_and_sprites():
	set_default_animations()
	set_default_sprites()

func set_default_animations():
	walk_up_animation_name = default_walk_up_animation_name
	walk_side_animation_name = default_walk_side_animation_name
	walk_down_animation_name = default_walk_down_animation_name
	
func set_default_sprites():
	sprite_side = sprite_side_default
	sprite_down = sprite_down_default
	sprite_up = sprite_up_default
	
func look_at(pos):
	var direction_to = parent.global_position.direction_to(pos)
	var look_at_absolute_dir = Vector2(round(direction_to.x), round(direction_to.y))
	if look_at_absolute_dir == Vector2.LEFT: sprite.scale.x = -1
	correct_facing_str(look_at_absolute_dir)
	correct_sprite_on_facing_str()
	direction = Vector2.ZERO
	absolute_dir = Vector2.ZERO
	previous_dir = Vector2.ZERO

func _on_player_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack") && parent.can_move: cancel_attack()

func cancel_attack():
	melee_hitbox.scale = Vector2(1, 1)
	parent.attacking = false
	if melee_hitbox != null: melee_hitbox.get_child(0).disabled = true
	correct_sprite_on_facing_str()
