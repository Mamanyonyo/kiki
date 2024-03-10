extends BasicEnemy

@export var event_shape: CollisionShape2D
@export var JumpCDTimer: Timer
@export var area_cd_timer: Timer
@export var sprite: Sprite2D

@export var percentage_to_activate_attack: float = 0.75
@export var min_random_time_range: float = 1
@export var max_random_time_range: float = 3

var tilemap: TileMap

enum{
	DEFAULT,
	CHASING_CLOSEST_TOILET,
	IN_TOILET,
	SPECIAL_ATTACK
}

var state = DEFAULT
var hp_to_attack_threshold: int
var objective_direction: Vector2 = Vector2(0, 0)
var selected_toilet_tilemap_pos: Vector2i
var closest_toilet_pos: Vector2

var jumped = 0




func _ready():
	hp_to_attack_threshold = health_component.max_health

func _process(_delta):
	match state:
		CHASING_CLOSEST_TOILET:
			velocity_component.accelerate_in_direction(objective_direction)
			velocity_component.move(self)
		SPECIAL_ATTACK:
			velocity = objective_direction * (velocity_component.max_speed + velocity_component.bonus_speed)
			move_and_slide()
		IN_TOILET: pass
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
	var tilemap_pos = tilemap.get_coords_for_body_rid(body_rid)
	var not_in_the_same_axis = tilemap_pos.x != selected_toilet_tilemap_pos.x && tilemap_pos.y != selected_toilet_tilemap_pos.y
	var distance_between_toilets = abs(abs(tilemap_pos.x - selected_toilet_tilemap_pos.x) - abs(tilemap_pos.y - selected_toilet_tilemap_pos.y))
	var is_opposite_side = distance_between_toilets == 9 || distance_between_toilets == 11
	if !body.is_in_group("player") && state != DEFAULT && (state == CHASING_CLOSEST_TOILET || state == SPECIAL_ATTACK) && (not_in_the_same_axis || is_opposite_side) || jumped == 0 && state != IN_TOILET:
		if jumped == 3:
			velocity_component.max_speed += 25
			return return_to_default()
		state = IN_TOILET
		objective_direction = Vector2(0, 0)
		visible = false
		sprite.frame_coords.x = 0
		sprite.frame_coords.y = 1
		sprite.position.y = 0
		selected_toilet_tilemap_pos = tilemap_pos
		change_tile_based_on_tilemap_pos(selected_toilet_tilemap_pos)
		closest_toilet_pos = tilemap.global_position + Vector2(tilemap.local_to_map(tilemap.map_to_local(selected_toilet_tilemap_pos))) * 16 + Vector2(8, 8)
		velocity_component.bonus_speed = 500
		event_shape.set_deferred("disabled", true)
		var rng = RandomNumberGenerator.new()
		var random_time = rng.randi_range(min_random_time_range, max_random_time_range)
		health_component.bonus_resistance = 3
		JumpCDTimer.start(random_time)

func return_to_default():
	visible = true
	sprite.frame_coords.y = 0
	sprite.frame_coords.x = 0
	velocity_component.bonus_speed = 0
	sprite.rotation_degrees = 0
	sprite.rotation = 0
	sprite.position.y = -16
	change_tile_based_on_tilemap_pos(selected_toilet_tilemap_pos, true)
	event_shape.set_deferred("disabled", true)
	jumped = 0
	health_component.bonus_resistance = 0
	state = DEFAULT

func _on_timer_timeout() -> void:
	health_component.bonus_resistance = -3
	jumped += 1
	state = SPECIAL_ATTACK
	global_position = closest_toilet_pos
	change_tile_based_on_tilemap_pos(selected_toilet_tilemap_pos, true)
	event_shape.set_deferred("disabled", false)
	var player_center = get_tree().get_first_node_in_group("Player").get_node("Sprite2D/Middle").global_position
	objective_direction = (player_center - global_position).normalized()
	sprite.look_at(player_center)
	visible = true
	
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
	change_tile_based_on_tilemap_pos(selected_toilet_tilemap_pos, true)
	tilemap.clear_layer(1)
	tilemap.clear_layer(2)
	tilemap.clear_layer(3)
