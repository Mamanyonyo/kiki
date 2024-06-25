extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.show_cg.connect(on_show_cg)
	GameEvents.stop_cg.connect(on_stop_cg)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_show_cg(path):
	texture = load(path)
	visible = true
	
func on_stop_cg():
	visible = false
