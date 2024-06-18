extends Label

@onready var main = preload("res://scenes/main/main.tscn")


func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		get_tree().change_scene_to_packed(main)
