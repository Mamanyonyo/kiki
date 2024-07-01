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
@onready var projectile_sfx_scene = preload("res://scenes/components/sfx/projectile_sfx.tscn")
@onready var teleport_sfx_path = "res://assets/sfx/magic-gravity1.mp3"


func _ready() -> void:
	player = get_parent().player
	stats_component = player.stats_component

func Inputs(event):
	for spell in spell_component.available_spells:
		if InputMap.has_action(spell) && Input.is_action_just_pressed(spell) && !player.attacking:
			if Input.is_key_pressed(KEY_CTRL) && !InputMap.action_get_events(spell)[0].ctrl_pressed: continue
			try_spell_cast(spell)
			return
	melee_atack_listen()

func melee_atack_listen():
	if Input.is_action_just_pressed("attack") && !player.attacking && !player.interacting:
		sprite_manager.melee_hitbox.get_child(0).disabled = false
		sprite_manager.melee_hitbox.damage = player.stats_component.damage
		play_and_set_attacking_state(weapon_name_animation_prefix + "_attack")
		check_if_animation_worked(weapon_name_animation_prefix + "_attack")
		var sound_manager = get_tree().get_first_node_in_group("sound") as SoundManager
		sound_manager.play("Melee")

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
	play_and_set_attacking_state(weapon_name_animation_prefix + "_attack_spell_aimed")
	check_if_animation_worked(weapon_name_animation_prefix + "_attack_spell_aimed")
	tp_timer.start()
	DataImport.skill_data["teleport"].cost = DataImport.skill_data["teleport"].cost * 2
	spell_component.available_spells_updated.emit()
	var previous_pos = player.global_position
	player.global_position = player.get_global_mouse_position()
	var space_state = player.get_world_2d().direct_space_state
	var RAYCAST_DISTANCE = 5000
	var directions = [Vector2.UP + Vector2.LEFT, Vector2.UP + Vector2.RIGHT, Vector2.RIGHT + Vector2.DOWN, Vector2.DOWN + Vector2.LEFT, Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	var hit = []
	var valid = true
	for direction in directions:
		var query = PhysicsRayQueryParameters2D.create(player.global_position, player.global_position + direction * RAYCAST_DISTANCE, pow(2, 1-1) + pow(2, 7-1))
		var result = space_state.intersect_ray(query)
		if result:
			if !result.collider is TileMap: 
				hit.push_front(result)
				continue
			if result.position.distance_to(player.global_position) <= 1:
					valid = false
			var tilemap = result.collider as TileMap
			var tile_coords = tilemap.get_coords_for_body_rid(result.rid)
			var tile_layer = tilemap.get_layer_for_body_rid(result.rid)
			var atlas_coords = tilemap.get_cell_atlas_coords(tile_layer, tile_coords) as Vector2i
			if direction == Vector2.UP:
					if (atlas_coords == Vector2i(2,1) || atlas_coords == Vector2i(2, 0)) || atlas_coords != Vector2i(1,0) && atlas_coords != Vector2i(3,0) && atlas_coords != Vector2i(3,1) && atlas_coords != Vector2i(3,2) && atlas_coords != Vector2i(2,2) && atlas_coords != Vector2i(1,2) && atlas_coords != Vector2i(1,1) && atlas_coords != Vector2i(1,0):
						hit.push_front(result)
					else: valid = false
			else:
				hit.push_front(result)
			var click_coords_to_local = tilemap.local_to_map(tilemap.to_local(player.global_position))
			for layer in tilemap.get_layers_count():
				var tile_data = tilemap.get_cell_tile_data(layer, click_coords_to_local) as TileData
				if tile_data:
					if tile_data.get_collision_polygons_count(0) > 0 || tile_data.get_collision_polygons_count(1) > 0: 
						valid = false
		else: valid = false
	if !valid && !GameEvents.debug:
		player.global_position = previous_pos
		#player.health_component.damage(3)
		return
		##TODO tpear al player al tile mas cercano
	get_tree().get_first_node_in_group("sound").play("Teleport")

func paralyze():
	play_and_set_attacking_state(weapon_name_animation_prefix + "_attack_spell_aimed")
	check_if_animation_worked(weapon_name_animation_prefix + "_attack_spell_aimed")
	var paralyze_instance = paralyze_scene.instantiate()
	get_tree().get_first_node_in_group("entities_layer").add_child(paralyze_instance)
	paralyze_instance.global_position = player.get_global_mouse_position()
	
func get_skill_data(name):
	return DataImport.skill_data[name]

func try_spell_cast(name):
	if player.attacking: return
	if !spell_component.available_spells.has(name):
		print("No tiene hechizo " + name) 
		return
	var skill_data = get_skill_data(name)
	if mana_component.cast_and_check(skill_data.cost): 
		var circle_instance = cast_circle_scene.instantiate() as Node2D
		player.get_node("PlayerFloor").add_child(circle_instance)
		circle_instance.global_position = player.global_position
		call(name)
	else:
		print("not enough mana to cast " + name + " " + str(skill_data.cost))
