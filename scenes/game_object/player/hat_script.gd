extends Sprite2D

@export var default_y = -6
@export var player : Player

var offset_y = 0

func _on_player_changed_facing_direction() -> void:
	if vframes * hframes > 1:
		match player.absolute_dir:
			Vector2.UP: frame = 1
			Vector2.DOWN: frame = 0
			_: frame = 2
	position.y = default_y


func _on_player_animator_animation_finished(anim_name: StringName) -> void:
	position.y = default_y


func _on_player_animator_current_animation_changed(name: String) -> void:
	position.y = default_y
