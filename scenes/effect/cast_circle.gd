extends Node2D

@onready var timer = $Timer
@onready var fade_player = $FadeInAndOut



func _on_timer_timeout() -> void:
	fade_player.play("fade_out")
	



func _on_fade_in_and_out_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		queue_free()
