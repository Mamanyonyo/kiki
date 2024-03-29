extends HBoxContainer

@export var experience_manager: ExperienceManager
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var level_label: Label = $Label

func _ready():
	experience_manager.experience_updated.connect(on_exp_updated)
	update()

func on_exp_updated():
	update()

func update():
	progress_bar.value = (experience_manager.current_experience*100)/experience_manager.next_level_xp
	level_label.text = str(experience_manager.current_level)
