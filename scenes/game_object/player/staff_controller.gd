extends WeaponController

var beam_scene : PackedScene = load("res://scenes/game_object/laser_beam/Laser.tscn")
var prev_sprite

func Inputs():
	melee_atack_listen("staff_attack")
	range_atack_listen("staff_attack_spell_aimed")
	
	if Input.is_key_pressed(KEY_C) && !player.attacking:
		var beam_instance = beam_scene.instantiate() as LaserBeam
		get_tree().get_first_node_in_group("foreground_layer").add_child(beam_instance)
		player.attacking = true
		player.can_move = false
		player.direction = Vector2.ZERO
		player.movement_animator.stop()
		prev_sprite = player.sprite.frame
		if player.get_facing_direction().x == -1: 
			beam_instance.rotation_degrees = 180
			beam_instance.global_position = generic_bullet_spawn_side.global_position
			player.sprite.frame = 29
		elif player.get_facing_direction().y == 1: 
			beam_instance.rotation_degrees = 90
			beam_instance.global_position = generic_bullet_spawn.global_position
			player.sprite.frame = 27
		elif player.get_facing_direction().y == -1: 
			beam_instance.rotation_degrees = 270
			beam_instance.global_position = generic_bullet_spawn.global_position
			player.sprite.frame = 28
		else:
			beam_instance.rotation_degrees = 0
			beam_instance.global_position = generic_bullet_spawn_side.global_position
			player.sprite.frame = 29
		beam_instance.collided.connect(on_end_condition)
		beam_instance.tree_exited.connect(on_end_condition)

func on_end_condition():
	print("end")
	player.attacking = false
	player.can_move = true
	player.sprite.frame = prev_sprite
