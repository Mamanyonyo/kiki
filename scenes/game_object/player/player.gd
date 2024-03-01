extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

@export var health_component: HealthComponent
@export var damage_timer: Timer

@export var hp_bar: ProgressBar

var colliding_bodies = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_health_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)

func _on_area_2d_area_entered(area):
	print("asd")
	health_component.damage(5)

func check_deal_damage():
	if colliding_bodies == 0 || !damage_timer.is_stopped(): return
	health_component.damage(1)
	damage_timer.start()

func update_health_display():
	hp_bar.value = health_component.get_health_percent()

func _on_collision_area_2d_body_entered(body: Node2D) -> void:
	colliding_bodies += 1
	check_deal_damage()

func _on_collision_area_2d_body_exited(body: Node2D) -> void:
	colliding_bodies -= 1

func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()

func _on_health_component_health_changed() -> void:
	update_health_display()
