class_name MainModulate extends CanvasModulate

func change_and_reset(opacity, time, reset_time):
	var tween = change_opacity(opacity, time) as Tween
	tween.finished.connect(change_opacity.bind(1, reset_time))

func change_opacity(opacity, time):
	var tween = create_tween()
	tween.tween_property(self, "color:a", opacity, time)
	return tween
	
func reset():
	color.a = 1
