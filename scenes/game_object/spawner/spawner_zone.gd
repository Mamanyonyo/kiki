class_name ZoneSpawner extends EnemySpawner

@export var terminal : Node2D
@export var custom_det_range = 400
@export var parent_area : Area

var spawned = []

func _ready():
	if terminal != null: 
		terminal.get_node("HealthComponent").died.connect(disable)
	parent_area.left.connect(on_area_leave)
	parent_area.entered.connect(enable)
	if parent_area.in_area: enable()
	
func _on_timer_timeout():
	animation_player.play("rotate")
	var enemy = spawn()
	enemy.detection_range = custom_det_range
	spawned.push_front(enemy)

func on_area_leave():
	for enemy in spawned:
		if is_instance_valid(enemy): enemy.queue_free()
	spawned = []
	disable()
