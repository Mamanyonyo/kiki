class_name HatManager extends WeaponManager

func _ready():
	super._ready()
	var exp_manager = get_tree().get_first_node_in_group("experience_manager") as ExperienceManager
	exp_manager.leveled_up.connect(on_level_up)
	
func on_level_up():
	if current_controller != null:
		current_controller.Level_up()
