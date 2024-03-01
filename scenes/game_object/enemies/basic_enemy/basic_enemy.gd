class_name BasicEnemy extends CharacterBody2D

@onready var health_component = $HealthComponent
@onready var velocity_component = $VelocityComponent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("Player") as Node2D
	if player_node == null: return Vector2.ZERO
	return (player_node.global_position - global_position).normalized()
