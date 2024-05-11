class_name ExperienceVial extends quantifiable_drop

func collect():
	GameEvents.emit_experience_vial_collected(value)
	queue_free()
