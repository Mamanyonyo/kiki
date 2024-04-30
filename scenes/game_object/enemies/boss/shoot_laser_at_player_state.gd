extends State

@export var beam_scene : PackedScene
@export var orb : GirlCultBossOrb
@export var health_component : HealthComponent
var beam_instance : Line2D

var target_pos : Vector2

@onready var delay = $Timer

func _ready():
	health_component.died.connect(on_death)

func Enter():
	var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
	if orbs.size() == 1: 
		orb.girl.state_machine.on_child_transition("ChasePlayer")
		transitioned.emit("ReturnToGirl")
		return
	var player = get_tree().get_first_node_in_group("Player") as Player
	target_pos = player.middle.global_position
	delay.start()

func Exit():
	delay.stop()
	if beam_instance != null: 
		beam_instance.queue_free()


func _on_timer_timeout():
	beam_instance = beam_scene.instantiate()
	beam_instance.global_position = orb.center.global_position
	get_tree().get_first_node_in_group("foreground_layer").add_child(beam_instance)
	beam_instance.look_at(target_pos)
	var orbs = get_tree().get_nodes_in_group("yellow_orb_boss")
	var i = 0
	var this_orb_index : float
	for current_orb : GirlCultBossOrb in orbs:
		if current_orb.get_rid() == orb.get_rid(): this_orb_index = i
		i += 1
	var next_orb_index : float = this_orb_index + 1
	if next_orb_index >= orbs.size(): next_orb_index = 0
	var next_orb : GirlCultBossOrb = orbs[next_orb_index]
	next_orb.state_machine.on_child_transition("GoToPlayerPos")

func on_death():
	if orb.state_machine.current_state.name == name && beam_instance != null:
		beam_instance.queue_free()
