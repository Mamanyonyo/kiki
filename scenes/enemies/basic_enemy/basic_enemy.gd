extends CharacterBody2D

const MAX_SPEED = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("Player") as Node2D
	return (player_node.global_position - global_position).normalized()


func _on_area_2d_area_entered(_area):
	queue_free()
