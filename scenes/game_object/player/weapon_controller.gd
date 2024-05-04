class_name MagicWeaponController extends EquipmentController

var player : Player

@export var fireball_scene : PackedScene
@export var generic_bullet_spawn : Marker2D
@export var generic_bullet_spawn_side : Marker2D
@export var stats_component : StatsComponent
@export var mana_component : ManaComponent
@export var weapon_name_animation_prefix : String
@export var spell_component : SpellsComponent
@export var tp_timer : Timer
@onready var cast_circle_scene = preload("res://scenes/effect/cast_circle.tscn")
@onready var paralyze_scene = preload("res://scenes/effect/paralyze.tscn")
@export var sprite_manager : SpriteManager


func _ready() -> void:
	player = get_parent().player
	stats_component = player.stats_component

func Inputs(event):
	melee_atack_listen()
	range_atack_listen()
	teleport_listen()
	paralyze_listen()

func melee_atack_listen():
	if Input.is_action_just_pressed("attack") && !player.attacking:
		sprite_manager.melee_hitbox.get_child(0).disabled = false
		sprite_manager.melee_hitbox.damage = player.stats_component.damage
		play_and_set_attacking_state(weapon_name_animation_prefix + "_attack")
		check_if_animation_worked(weapon_name_animation_prefix + "_attack")

func range_atack_listen():
	if Input.is_action_just_pressed("attack2") && !player.attacking && !Input.is_action_just_pressed("teleport"):
		try_spell_cast("fireball")
		
func teleport_listen():
	if Input.is_action_just_pressed("teleport"):
		try_spell_cast("teleport")
		
func paralyze_listen():
	if Input.is_key_pressed(KEY_V) && !player.attacking:
		play_and_set_attacking_state(weapon_name_animation_prefix + "_attack_spell_aimed")
		try_spell_cast("paralyze")

func play_and_set_attacking_state(animation_prefix: String):
	player.attacking = true
	sprite_manager.animator.play(animation_prefix + "_" + sprite_manager.facing_str)

func check_if_animation_worked(animation_name: String):
	if !sprite_manager.animator.assigned_animation == animation_name + "_" + sprite_manager.facing_str:
		player.attacking = false
		sprite_manager.melee_hitbox.get_child(0).disabled = true

func fireball():
	play_and_set_attacking_state(weapon_name_animation_prefix + "_attack_spell_aimed")
	check_if_animation_worked(weapon_name_animation_prefix + "_attack_spell_aimed")
	var skill_data = get_skill_data("fireball")
	var bullet_instance = fireball_scene.instantiate() as HitboxComponent
	bullet_instance.attacker = player
	bullet_instance.damage = skill_data.damage + stats_component.magic_damage
	match sprite_manager.get_rotation_in_degrees():
		90: bullet_instance.global_position = generic_bullet_spawn.global_position
		0: bullet_instance.global_position = generic_bullet_spawn_side.global_position
		270: bullet_instance.global_position = generic_bullet_spawn.global_position
		180: bullet_instance.global_position = generic_bullet_spawn_side.global_position
	bullet_instance.rotation_degrees = sprite_manager.get_rotation_in_degrees()
	get_tree().get_first_node_in_group("entities_layer").add_child(bullet_instance)
	
func teleport():
	tp_timer.start()
	DataImport.skill_data["teleport"].cost = DataImport.skill_data["teleport"].cost * 2
	var previous_pos = player.global_position
	player.global_position = player.get_global_mouse_position()
	var space_state = player.get_world_2d().direct_space_state
	var RAYCAST_DISTANCE = 5000
	var directions = [Vector2.UP + Vector2.LEFT, Vector2.UP + Vector2.RIGHT, Vector2.RIGHT + Vector2.DOWN, Vector2.DOWN + Vector2.LEFT, Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	var hit = []
	for direction in directions:
		var query = PhysicsRayQueryParameters2D.create(player.global_position, player.global_position + direction * RAYCAST_DISTANCE, pow(2, 1-1) + pow(2, 7-1))
		query.exclude = [player]
		var result = space_state.intersect_ray(query)
		if result: hit.push_front(result)
	if hit.size() != directions.size() && !GameEvents.debug:
		player.global_position = previous_pos
		player.health_component.damage(3)
		##TODO tpear al player al tile mas cercano
		##TODO hacer que el player no se pueda quedar atrapado entre paredes cerradas viendo el tile del lado opuesto de la colision

func paralyze():
	var paralyze_instance = paralyze_scene.instantiate()
	get_tree().get_first_node_in_group("entities_layer").add_child(paralyze_instance)
	paralyze_instance.global_position = player.get_global_mouse_position()
	
func get_skill_data(name):
	return DataImport.skill_data[name]

func try_spell_cast(name):
	if !spell_component.available_spells.has(name):
		print("No tiene hechizo " + name) 
		return
	var skill_data = get_skill_data(name)
	if mana_component.cast_and_check(skill_data.cost): 
		var circle_instance = cast_circle_scene.instantiate() as Node2D
		player.get_node("PlayerFloor").add_child(circle_instance)
		circle_instance.global_position = player.global_position
		call(name)
		
