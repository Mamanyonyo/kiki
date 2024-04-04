extends WeaponController

func Inputs():
	#melee_atack_listen("staff_attack")
	range_atack_listen("staff_attack_spell_aimed")

#func melee_atack_listen(animation_name: String):
	#if Input.is_action_just_pressed("attack") && !player.attacking:
		#player.book_hitbox.monitorable = true
		#player.book_hitbox.damage = player.stats_component.damage
		#play_and_set_attacking_state(animation_name)
		#check_if_animation_worked(animation_name)
