class_name BathroomGhostBoss extends BasicEnemy

@export var permanent_speed_increment : float
var block_layer
var top
var horizontal
var vertical
var tilemap : TileMap

var objective_direction: Vector2 = Vector2(0, 0)
var jumped = 0
var jump_limit = 3
var tile
var tile_layer

func _on_event_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if state_machine.current_state.name == "InToilet" || state_machine.current_state.name == "ChasePlayer": return
	var new_tile = tilemap.get_coords_for_body_rid(body_rid)
	tile_layer = tilemap.get_layer_for_body_rid(body_rid)
	if state_machine.current_state.name == "JumpAttack":
		var not_in_the_same_axis = tile.x != new_tile.x && tile.y != new_tile.y
		var distance_between_toilets = abs(abs(tile.x - new_tile.x) - abs(abs(tile.y - new_tile.y)))
		var is_opposite_side = distance_between_toilets == horizontal-1 || distance_between_toilets == vertical-1
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

func change_tile_based_on_tilemap_pos(reset):
	var new_tile = tilemap.get_cell_atlas_coords(tile_layer, tile)
	if reset:
		new_tile.y -= 2
	else:
		new_tile.y += 2
	tilemap.set_cell(top, tile, 1, new_tile)
