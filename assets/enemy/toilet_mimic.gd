extends BasicEnemy
@export var range_trigger = 100
@onready var sprite: Sprite2D = $Sprite2D

enum{
	STANDBY,
	CHASE
}

var state = STANDBY

func _process(_delta):
	match state:
		STANDBY:
			check_distance_to_player()
		CHASE:
			velocity_component.accelerate_to_player()
			velocity_component.move(self)
		_:
			pass
			
func check_distance_to_player():
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player != null:
		if player.global_position.distance_squared_to(global_position) < range_trigger:
			sprite.frame = 1
			state = CHASE


func _on_health_component_health_changed():
	state = CHASE
