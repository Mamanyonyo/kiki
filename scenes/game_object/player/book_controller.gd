extends Node

var player_animator : AnimationPlayer
var player : Player
var foreground_layer

@export var fireball_scene : PackedScene
@export var generic_bullet_spawn : Marker2D
@export var generic_bullet_spawn_side : Marker2D

func _ready() -> void:
	player = get_parent().player
	player_animator = player.movement_animator
	foreground_layer = get_tree().get_first_node_in_group("foreground_layer")

func _process(delta: float) -> void:
	melee_atack_listen("book_attack")
	range_atack_listen("book_attack_spell_aimed")

func melee_atack_listen(animation_name: String):
	if Input.is_action_just_pressed("attack") && !player.attacking:
		player.hitbox.monitorable = true
		play_and_set_attacking_state(animation_name)
		check_if_animation_worked(animation_name)

func range_atack_listen(animation_name: String):
	if Input.is_action_just_pressed("attack2") && !player.attacking:
		play_and_set_attacking_state(animation_name)
		check_if_animation_worked(animation_name)
		var bullet_instance = fireball_scene.instantiate() as Area2D
		match player.get_rotation_in_degrees():
			90: bullet_instance.global_position = generic_bullet_spawn.global_position
			0: bullet_instance.global_position = generic_bullet_spawn_side.global_position
			270: bullet_instance.global_position = generic_bullet_spawn.global_position - generic_bullet_spawn.position * 2
			180: bullet_instance.global_position = generic_bullet_spawn_side.global_position - generic_bullet_spawn_side.position * 2
		
		bullet_instance.rotation_degrees = player.get_rotation_in_degrees()
		foreground_layer.add_child(bullet_instance)
		

func play_and_set_attacking_state(animation_prefix: String):
	player.attacking = true
	player_animator.play(animation_prefix + "_" + player.facing_str)

func check_if_animation_worked(animation_name: String):
	if !player_animator.assigned_animation == animation_name + "_" + player.facing_str:
		player.attacking = false
