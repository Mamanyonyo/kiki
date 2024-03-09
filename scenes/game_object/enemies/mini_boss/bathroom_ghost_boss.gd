extends BasicEnemy

@export var event_shape: CollisionShape2D
@export var JumpCDTimer: Timer
@export var area_cd_timer: Timer
@export var sprite: Sprite2D

@export var percentage_to_activate_attack: float = 0.75
@export var min_random_time_range: float = 1.50
@export var max_random_time_range: float = 3

var tilemap: TileMap

enum{
	DEFAULT,
	CHASING_CLOSEST_TOILET,
	CORRECT_POSITION,
	SPECIAL_ATTACK
}

var state = DEFAULT
var hp_to_attack_threshold: int
var objective_direction: Vector2 = Vector2(0, 0)
var selected_toilet_tilemap_pos: Vector2i
var closest_toilet_pos: Vector2





func _ready():
	hp_to_attack_threshold = health_component.max_health

func _process(_delta):
	match state:
		CHASING_CLOSEST_TOILET:
			velocity_component.accelerate_in_direction(objective_direction)
			velocity_component.move(self)
		CORRECT_POSITION:
			global_position = closest_toilet_pos
			var player_center = get_tree().get_first_node_in_group("Player").get_node("Sprite2D/Middle").global_position
			sprite.look_at(player_center)
		SPECIAL_ATTACK:
			pass
		_:
			velocity_component.accelerate_to_player()
			velocity_component.move(self)

func _on_health_component_health_changed() -> void:
	if health_component.get_health_percent() < percentage_to_activate_attack && state == DEFAULT:
		state = CHASING_CLOSEST_TOILET
		percentage_to_activate_attack -= 0.25
		get_closest_toilet()
		
func get_closest_toilet():
	var toilet_local_positions = tilemap.get_used_cells(1) + tilemap.get_used_cells(2)
	var toilet_positions = toilet_local_positions.map(func(tile):
		return {"position": tilemap.global_position + Vector2(tilemap.local_to_map(tilemap.map_to_local(tile))) * 16, "local": tile}
		)
	toilet_positions.sort_custom(sort_closest)
	var closest_toilet = toilet_positions.front()
	closest_toilet_pos = closest_toilet["position"] + Vector2(8, 8)
	selected_toilet_tilemap_pos = closest_toilet["local"]
	objective_direction = (closest_toilet_pos - global_position).normalized()
	event_shape.set_deferred("disabled", false)

func sort_closest(a, b):
	return global_position.distance_squared_to(a["position"]) < global_position.distance_squared_to(b["position"])

func _on_event_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if !body.is_in_group("player") && (state == CHASING_CLOSEST_TOILET || state == SPECIAL_ATTACK):
		objective_direction = Vector2(0, 0)
		#visible = false
		sprite.frame_coords.y = 1
		
		selected_toilet_tilemap_pos = tilemap.get_coords_for_body_rid(body_rid)
		change_tile_based_on_tilemap_pos(selected_toilet_tilemap_pos)
		closest_toilet_pos = tilemap.global_position + Vector2(tilemap.local_to_map(tilemap.map_to_local(selected_toilet_tilemap_pos))) * 16 + Vector2(8, 8)
		
		velocity_component.max_speed = 500
		JumpCDTimer.start()
		state = CORRECT_POSITION

func _on_timer_timeout() -> void:
	state = CHASING_CLOSEST_TOILET
	global_position = closest_toilet_pos
	change_tile_based_on_tilemap_pos(selected_toilet_tilemap_pos, true)
	event_shape.set_deferred("disabled", true)
	var player_center = get_tree().get_first_node_in_group("Player").get_node("Sprite2D/Middle").global_position
	objective_direction = (player_center - closest_toilet_pos).normalized()
	sprite.look_at(player_center)
	visible = true
	area_cd_timer.start()

func _on_area_cd_timeout() -> void:
	event_shape.set_deferred("disabled", false)
	
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
