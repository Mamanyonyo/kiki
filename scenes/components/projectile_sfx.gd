extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("reparent", get_tree().get_first_node_in_group("sound"))

func _on_finished() -> void:
	queue_free()
