extends WeaponController


@export var viewer_marker : Marker2D
@export var beam_marker : Marker2D
@export var buster_charges_required : float = 14
#@export var beam_duration : float = 5
@onready var beam : PackedScene = load("res://scenes/effect/buster_beam.tscn")
@onready var letters_spawner : PackedScene = load("res://scenes/effect/cast_spawner_buster.tscn")
@onready var circle : PackedScene = load("res://scenes/effect/buster_circle.tscn")
@onready var buster_timer : Timer = $BusterTimer

var circle_instances : Array = []
var beam_instance
var letters_instance : SpawnerBusterLettersEffect

var prev_sprite : int
var charges = 0

func Inputs():
	melee_atack_listen("staff_attack")
	range_atack_listen("staff_attack_spell_aimed")
	
	if Input.is_key_pressed(KEY_C) && !player.attacking:
		player.attacking = true
		player.can_move = false
		player.direction = Vector2.ZERO
		player.movement_animator.stop()
		prev_sprite = player.sprite.frame
		spawn_circle(Vector2(2.5, 2.5), 0.8)
		player.movement_animator.play("staff_attack_hyperborea_buster_charge")
		
func spawn_circle(size: Vector2, time: float):
	var circle = circle.instantiate()
	circle_instances.push_back(circle)
	player.sprite.add_child(circle)
	circle.global_position = player.global_position
	circle.enter(size, time)

func on_end_beamer():
	player.attacking = false
	player.can_move = true
	player.sprite.frame = prev_sprite
	for circle in circle_instances:
		circle.queue_free()
	circle_instances = []
	beam_instance.queue_free()
	letters_instance.queue_free()
	charges = 0
	

func _on_player_animator_animation_finished(anim_name):
	match anim_name as String:
		"staff_attack_hyperborea_buster_charge":
			player_animator.play("staff_attack_hyperborea_buster_charge_limit")
			spawn_circle(Vector2(5, 5), 1)
		"staff_attack_hyperborea_buster_charge_limit":
			charges += 1
			if charges == buster_charges_required/2:
				spawn_circle(Vector2(8.5, 8.5), 1)
				letters_instance = letters_spawner.instantiate() as Node2D
				get_tree().get_first_node_in_group("foreground_layer").add_child(letters_instance)
				letters_instance.global_position = player.global_position + Vector2.DOWN * 200
			if charges == buster_charges_required-5:
				spawn_circle(Vector2(30, 30), buster_timer.wait_time+2)
			if charges >= buster_charges_required:
				player_animator.stop()
				player.sprite.frame = 49
				beam_instance = beam.instantiate()
				get_tree().get_first_node_in_group("foreground_layer").add_child(beam_instance)
				beam_instance.rotation = player.get_facing_direction().angle()
				beam_instance.global_position = beam_marker.global_position
				buster_timer.start()
				return
			else:
				player_animator.play("staff_attack_hyperborea_buster_charge_limit")



func _on_buster_timer_timeout():
	on_end_beamer()
