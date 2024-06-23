extends GenericInteractable

@export var event_area : GenericInteractable
@export var boss_girl_scene : PackedScene

func _ready():
	event_area.finish.connect(on_boss_event_enter)
	
func on_boss_event_enter():
	var boss_girl_instance : UnnamedCultGirlBoss = boss_girl_scene.instantiate()
	boss_girl_instance.global_position = global_position
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	get_tree().get_first_node_in_group("entities_layer").call_deferred("add_child", boss_girl_instance)
