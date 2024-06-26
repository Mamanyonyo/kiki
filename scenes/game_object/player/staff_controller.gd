class_name StaffController extends MagicWeaponController

@export var beam_marker : Marker2D
@export var beam_marker_side : Marker2D
@export var buster_charges_required : float = 14
#@export var beam_duration : float = 5
@onready var beam : PackedScene = load("res://scenes/effect/buster_beam.tscn")
@onready var letters_spawner : PackedScene = load("res://scenes/effect/cast_spawner_buster.tscn")
@onready var circle : PackedScene = load("res://scenes/effect/buster_circle.tscn")
@onready var buster_timer : Timer = $BusterTimer
@export var spells_component : SpellsComponent
@export var drive_component : DriveComponent
@export var weapon_manager : WeaponManager
@export var drive_attack_range : float = 100

var circle_instances : Array = []
var beam_instance
var letters_instance : SpawnerBusterLettersEffect

var prev_sprite : int
var charges = 0

func Inputs(event):
	if(!drive_component.drive):
		super.Inputs(event)
		if Input.is_key_pressed(KEY_C) && !player.attacking:
			try_spell_cast("hyperborea_buster")
			#if !mana_component.cast_and_check(temp_mana_cost): return

func Process(_delta):
	if drive_component.drive: Inputs_drive()

func hyperborea_buster():
	DataImport.skill_data["hyperborea_buster"].name = "Hyperborea Buster"
	spells_component.available_spells_updated.emit()
	player.attacking = true
	player.can_move = false
	sprite_manager.direction = Vector2.ZERO
	sprite_manager.animator.stop()
	prev_sprite = sprite_manager.sprite.frame
	spawn_circle(Vector2(2.5, 2.5), 0.8)
	sprite_manager.animator.play("staff_attack_hyperborea_buster_charge_" + sprite_manager.facing_str)

func spawn_circle(size: Vector2, time: float):
	var circle = circle.instantiate()
	circle_instances.push_back(circle)
	sprite_manager.sprite.add_child(circle)
	circle.global_position = player.global_position
	circle.enter(size, time)
	return circle

func on_end_beamer():
	player.attacking = false
	player.can_move = true
	sprite_manager.sprite.frame = prev_sprite
	for circle in circle_instances:
		circle.queue_free()
	circle_instances = []
	beam_instance.queue_free()
	letters_instance.queue_free()
	charges = 0
	get_tree().get_first_node_in_group("camera").shake = false
	get_tree().get_first_node_in_group("modulate").reset()
	player.reparent(get_tree().get_first_node_in_group("entities_layer"))
	

func _on_player_animator_animation_finished(anim_name: String):
	var name_arr : PackedStringArray = anim_name.split("_")
	name_arr.remove_at(name_arr.size()-1)
	var raw_name = "_".join(name_arr)
	match raw_name as String:
		"staff_attack_hyperborea_buster_charge":
			sprite_manager.animator.play("staff_attack_hyperborea_buster_charge_limit_" + sprite_manager.facing_str)
			spawn_circle(Vector2(5, 5), 0.8)
		"staff_attack_hyperborea_buster_charge_limit":
			charges += 1
			if charges == buster_charges_required/2:
				spawn_circle(Vector2(8.5, 8.5), 1)
				letters_instance = letters_spawner.instantiate() as Node2D
				get_tree().get_first_node_in_group("foreground_layer").add_child(letters_instance)
				letters_instance.global_position = player.global_position + Vector2.DOWN * 200
			if charges == buster_charges_required-5:
				spawn_circle(Vector2(30, 30), buster_timer.wait_time+2).set_opacity(0.6)
				player.reparent(get_tree().get_first_node_in_group("foreground_layer"))
				get_tree().get_first_node_in_group("modulate").change_opacity(0.2, 1)
			if charges >= buster_charges_required:
				var skill_data = get_skill_data("hyperborea_buster")
				sprite_manager.animator.stop()
				beam_instance = beam.instantiate()
				beam_instance.damage = skill_data.damage + stats_component.magic_damage
				beam_instance.attacker = player
				get_tree().get_first_node_in_group("foreground_layer").add_child(beam_instance)
				beam_instance.rotation = sprite_manager.get_facing_direction().angle()
				match sprite_manager.get_facing_direction():
					Vector2.UP: 
						sprite_manager.sprite.frame = 67
						beam_instance.global_position = beam_marker.global_position
					Vector2.DOWN: 
						sprite_manager.sprite.frame = 49
						beam_instance.global_position = beam_marker.global_position
					_: 
						sprite_manager.sprite.frame = 58
						beam_instance.global_position = beam_marker_side.global_position
				buster_timer.start()
				get_tree().get_first_node_in_group("camera").shake = true
				return
			else:
				sprite_manager.animator.play("staff_attack_hyperborea_buster_charge_limit_" + sprite_manager.facing_str)

func _on_buster_timer_timeout():
	on_end_beamer()

func _on_drive_component_drive_start():
	if weapon_manager.current_controller.item_id != item_id: return
	Drive_enter()

func Drive_enter():
	stats_component.damage += stats_component.magic_damage
	drive_set_sprites_and_animations()
	
func drive_set_sprites():
	sprite_manager.sprite_down = 68
	sprite_manager.sprite_up = 70
	sprite_manager.sprite_side = 72
	
func drive_set_animations():
	sprite_manager.walk_down_animation_name = "staff_drive_walk_down"
	sprite_manager.walk_side_animation_name = "staff_drive_walk_side"
	sprite_manager.walk_up_animation_name = "staff_drive_walk_up"
	
func drive_set_sprites_and_animations():
	drive_set_sprites()
	drive_set_animations()

func Drive_exit():
	stats_component.damage = stats_component.max_damage

func Inputs_drive():
	if Input.is_action_pressed("attack"):
		if $DriveHitTime.is_stopped():
			$DriveHitTime.start()
			var enemies : Array = get_tree().get_nodes_in_group("Enemy")
			#var enemies_in_range : Array = []
			var hit = false
			for enemy : BasicEnemy in enemies:
				if enemy.global_position.distance_to(player.global_position) < drive_attack_range:
					#enemies_in_range.push_back(enemy)
					enemy.health_component.damage(stats_component.damage/2)
					hit = true
			if hit:
				sprite_manager.walk_down_animation_name = "staff_drive_walk_down_attack"
				sprite_manager.walk_side_animation_name = "staff_drive_walk_side_attack"
				sprite_manager.sprite_down = 74
				sprite_manager.sprite_side = 76
			else: drive_set_sprites_and_animations()
				
	else:
		drive_set_sprites_and_animations()

func try_spell_cast(spell):
	if drive_component.drive: return
	super.try_spell_cast(spell)
