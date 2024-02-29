extends CanvasLayer

@export var experience_manager: ExperienceManager
@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar

func _ready():
	experience_manager.experience_updated.connect(on_exp_updated)

func on_exp_updated(current_experience: float, target_experience: float):
	progress_bar.value = (current_experience*100)/target_experience
