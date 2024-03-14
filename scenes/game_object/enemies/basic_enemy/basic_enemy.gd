class_name BasicEnemy extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var stats_component: StatsComponent = $StatsComponent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func _on_health_component_died():
	queue_free()
