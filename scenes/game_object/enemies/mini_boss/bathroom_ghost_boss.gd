class_name BathroomGhostBoss extends BasicEnemy

@export var permanent_speed_increment : float
var tilemap : TileMap

var objective_direction: Vector2 = Vector2(0, 0)
var jumped = 0
var jump_limit = 3
var tile

func _on_event_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if state_machine.current_state.name == "InToilet" || state_machine.current_state.name == "ChasePlayer": return
	var new_tile = tilemap.get_coords_for_body_rid(body_rid)
	if state_machine.current_state.name == "JumpAttack":
		var not_in_the_same_axis = tile.x != new_tile.x && tile.y != new_tile.y
		var distance_between_toilets = abs(abs(tile.x - new_tile.x) - abs(abs(tile.y - new_tile.y)))
		var is_opposite_side = distance_between_toilets == 9 || distance_between_toilets == 11
		if !not_in_the_same_axis && !is_opposite_side: 
			return
		tile = new_tile
	else: 
		tile = new_tile
	if jumped <= jump_limit:
		state_machine.on_child_transition("InToilet")
	else:
		stats_component.max_speed += permanent_speed_increment
		jumped = 0
		state_machine.on_child_transition("ChasePlayer")
		tile = null

func change_tile_based_on_tilemap_pos(pos: Vector2i, reset = false):
	var new_tile: Vector2i
	if pos.y == 7:
		new_tile = Vector2i(9, 2)
	elif pos.x == 13:
		new_tile = Vector2i(10, 2)
	elif pos.x == 24:
		new_tile = Vector2i(11, 2)
	elif pos.y == 16:
		new_tile = Vector2i(9, 3)
	
	if reset:
		new_tile.y -= 2
		
	tilemap.set_cell(3, pos, 1, new_tile)

func _on_health_component_died():
	tilemap.clear_layer(1)
	tilemap.clear_layer(2)
	tilemap.clear_layer(3)
	queue_free()
