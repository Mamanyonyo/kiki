class_name MainModulate extends CanvasModulate


func change_opacity(opacity, time):
	var tween = create_tween()
	tween.tween_property(self, "color:a", opacity, time)
	
func reset():
	color.a = 1
