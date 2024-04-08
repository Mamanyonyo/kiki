extends WeaponController


@export var viewer_marker : Marker2D
@export var beam_marker : Marker2D
@export var buster_charges_required : float = 14
#@export var beam_duration : float = 5
@onready var beam : PackedScene = load("res://scenes/effect/buster_beam.tscn")
@onready var letters_spawner : PackedScene = load("res://scenes/effect/cast_spawner_buster.tscn")
@onready var circle : PackedScene = load("res://scenes/effect/buster_circle.tscn")
@onready var buster_timer : Timer = $BusterTimer

var circle_instance
var beam_instance
var letters_instance

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
		circle_instance = circle.instantiate() as Node2D
		player.sprite.add_child(circle_instance)
		circle_instance.global_position = player.global_position
		letters_instance = letters_spawner.instantiate() as Node2D
		player.sprite.add_child(letters_instance)
		letters_instance.global_position = player.global_position
		player.movement_animator.play("staff_attack_hyperborea_buster_charge")

func on_end_beamer():
	print("end")
	player.attacking = false
	player.can_move = true
	player.sprite.frame = prev_sprite
	circle_instance.queue_free()
	beam_instance.queue_free()
	letters_instance.queue_free()
	charges = 0
	

func _on_player_animator_animation_finished(anim_name):
	match anim_name as String:
		"staff_attack_hyperborea_buster_charge":
			player_animator.play("staff_attack_hyperborea_buster_charge_limit")
		"staff_attack_hyperborea_buster_charge_limit":
			charges += 1
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
