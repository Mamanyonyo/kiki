extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, next_level_xp: float)
signal leveled_up(current_level: float)

var current_experience = 0
var current_level = 1
var next_level_xp = 1 + current_level * 5

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

func increment_experience(exp):
	current_experience += exp
	level_up_check()
	experience_updated.emit(current_experience, next_level_xp)
	
func level_up_check():
	if current_experience >= next_level_xp: level_up()
	
func level_up():
	current_level += 1
	current_experience = 0 + current_experience - next_level_xp
	next_level_xp = 10 + current_level * 5
	leveled_up.emit(current_level)
	

func on_experience_vial_collected(exp: float):
	increment_experience(exp)
