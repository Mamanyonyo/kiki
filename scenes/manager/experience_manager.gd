extends Node
class_name ExperienceManager

signal experience_updated
signal leveled_up(current_level: float)

var current_experience = 0
var current_level = 1
var next_level_xp = 1 + current_level * 5

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

func increment_experience(exp):
	current_experience += exp
	experience_updated.emit()
	level_up_check()
	
func level_up_check():
	if current_experience >= next_level_xp: level_up()
	
func level_up():
	var sobra = current_experience - next_level_xp
	if sobra < 0: sobra = 0
	current_level += 1
	next_level_xp = 10 + current_level * 5
	leveled_up.emit(current_level)
	current_experience = 0 + sobra
	level_up_check()
	

func on_experience_vial_collected(exp: float):
	increment_experience(exp)
