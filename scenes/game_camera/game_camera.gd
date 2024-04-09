extends Camera2D

@export var ui_box : BoxContainer
@export var random_strength: float = 30.0
@export var shake_fade: float = 5.0
var target_position = Vector2.ZERO

var rng = RandomNumberGenerator.new()

var thug_shaker_strength: float = 0.0

var shake = false

# Called when the node enters the scene tree for the first time.
func _ready():
	make_current();
	
func apply_shake():
	thug_shaker_strength = random_strength


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target();
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))
	if shake:
		apply_shake()
		thug_shaker_strength = lerpf(thug_shaker_strength, 0, shake_fade * delta)
		offset = random_offset()

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-thug_shaker_strength, thug_shaker_strength), rng.randf_range(-thug_shaker_strength, thug_shaker_strength))

func acquire_target():
	var player_node = get_tree().get_first_node_in_group("Player") as Node2D;
	if player_node == null: return
	target_position = Vector2(player_node.global_position.x + ui_box.size.x/2, player_node.global_position.y);
