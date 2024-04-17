class_name MagicWeaponController extends EquipmentController

var player_animator : AnimationPlayer
var player : Player

@export var fireball_scene : PackedScene
@export var generic_bullet_spawn : Marker2D
@export var generic_bullet_spawn_side : Marker2D
@export var stats_component : StatsComponent
@export var mana_component : ManaComponent
@export var weapon_name_animation_prefix : String
@onready var cast_circle_scene = preload("res://scenes/effect/cast_circle.tscn")

func _ready() -> void:
	player = get_parent().player
	player_animator = player.movement_animator
	stats_component = player.stats_component

func Inputs(event):
	melee_atack_listen()
	range_atack_listen()

func melee_atack_listen():
	if Input.is_action_just_pressed("attack") && !player.attacking:
		player.book_hitbox.get_child(0).disabled = false
		player.book_hitbox.damage = player.stats_component.damage
		play_and_set_attacking_state(weapon_name_animation_prefix + "_attack")
		check_if_animation_worked(weapon_name_animation_prefix + "_attack")

func range_atack_listen():
	if Input.is_action_just_pressed("attack2") && !player.attacking:
		try_spell_cast("fireball")

func play_and_set_attacking_state(animation_prefix: String):
	player.attacking = true
	player_animator.play(animation_prefix + "_" + player.facing_str)

func check_if_animation_worked(animation_name: String):
	if !player_animator.assigned_animation == animation_name + "_" + player.facing_str:
		player.attacking = false
		player.book_hitbox.get_child(0).disabled = true

func fireball():
	play_and_set_attacking_state(weapon_name_animation_prefix + "_attack_spell_aimed")
	check_if_animation_worked(weapon_name_animation_prefix + "_attack_spell_aimed")
	var skill_data = get_skill_data("fireball")
	var bullet_instance = fireball_scene.instantiate() as HitboxComponent
	bullet_instance.attacker = player
	bullet_instance.damage = skill_data.damage + stats_component.magic_damage
	match player.get_rotation_in_degrees():
		90: bullet_instance.global_position = generic_bullet_spawn.global_position
		0: bullet_instance.global_position = generic_bullet_spawn_side.global_position
		270: bullet_instance.global_position = generic_bullet_spawn.global_position
		180: bullet_instance.global_position = generic_bullet_spawn_side.global_position
	bullet_instance.rotation_degrees = player.get_rotation_in_degrees()
	get_tree().get_first_node_in_group("entities_layer").add_child(bullet_instance)
	
func get_skill_data(name):
	return DataImport.skill_data[name]

func try_spell_cast(name):
	var skill_data = get_skill_data(name)
	if mana_component.cast_and_check(skill_data.cost): 
		var circle_instance = cast_circle_scene.instantiate() as Node2D
		get_tree().get_first_node_in_group("floor_layer").add_child(circle_instance)
		circle_instance.global_position = player.global_position
		call(name)
		
