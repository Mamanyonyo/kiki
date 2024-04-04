class_name WeaponController extends Node

var player_animator : AnimationPlayer
var player : Player

@export var fireball_scene : PackedScene
@export var generic_bullet_spawn : Marker2D
@export var generic_bullet_spawn_side : Marker2D
@export var stats_component : StatsComponent

func _ready() -> void:
	player = get_parent().player
	player_animator = player.movement_animator
	stats_component = player.stats_component

func Inputs():
	melee_atack_listen("book_attack")
	range_atack_listen("book_attack_spell_aimed")

func melee_atack_listen(animation_name: String):
	if Input.is_action_just_pressed("attack") && !player.attacking:
		player.book_hitbox.monitorable = true
		player.book_hitbox.damage = player.stats_component.damage
		play_and_set_attacking_state(animation_name)
		check_if_animation_worked(animation_name)

func range_atack_listen(animation_name: String):
	if Input.is_action_just_pressed("attack2") && !player.attacking:
		play_and_set_attacking_state(animation_name)
		check_if_animation_worked(animation_name)
		var bullet_instance = fireball_scene.instantiate() as HitboxComponent
		bullet_instance.damage = stats_component.magic_damage
		match player.get_rotation_in_degrees():
			90: bullet_instance.global_position = generic_bullet_spawn.global_position
			0: bullet_instance.global_position = generic_bullet_spawn_side.global_position
			270: bullet_instance.global_position = generic_bullet_spawn.global_position
			180: bullet_instance.global_position = generic_bullet_spawn_side.global_position
		
		bullet_instance.rotation_degrees = player.get_rotation_in_degrees()
		get_tree().get_first_node_in_group("entities_layer").add_child(bullet_instance)
		

func play_and_set_attacking_state(animation_prefix: String):
	player.attacking = true
	player_animator.play(animation_prefix + "_" + player.facing_str)

func check_if_animation_worked(animation_name: String):
	if !player_animator.assigned_animation == animation_name + "_" + player.facing_str:
		player.attacking = false
