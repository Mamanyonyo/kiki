extends Node2D


# Called when the node enters the scene tree for the first time.

	
func _on_area_2d_area_entered(area):
	GameEvents.emit_experience_vial_collected(1)
	queue_free()
	
