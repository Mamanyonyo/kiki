class_name ZoneSpawner extends EnemySpawner

@export var terminal : Node2D

func _ready():
	terminal.tree_exited.connect(disable)
	enable()
	
func _on_timer_timeout():
	animation_player.play("rotate")
	var enemy = spawn()
