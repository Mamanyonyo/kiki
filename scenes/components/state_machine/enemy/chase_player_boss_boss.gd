class_name UnnamedCultGirlBossChase extends ChasePlayer

@onready var timer : Timer = $Timer
@export var girl : UnnamedCultGirlBoss

@export var last_attack_threshold = 15
@export var thresholds = [85, 55]
@export var finish_thresholds = [60, 25]
@export var orb_state = ["LaserCage", "GoToPlayerPos"]

var last_attack_mode = false
var current_attack_index = 0

func Enter():
	super.Enter()
	timer.start()
	
func Update(_delta):
	var percentage = get_percentage()
	
	if current_attack_index < thresholds.size() && percentage < thresholds[current_attack_index]:
		transitioned.emit("Casting")
		return
	
	if percentage < last_attack_threshold && !last_attack_mode:
		last_attack_mode = true
		timer.stop()
		for orb in girl.current_orbs:
			if orb != null: 
				orb.state_machine.on_child_transition("LockIn")
	
	super.Update(_delta)
	
func Exit():
	timer.stop()
	super.Exit()


func _on_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("yellow_orb_boss").size() == 0: return
	transitioned.emit("Throwing")
	
func get_percentage():
	var current_total_hp = girl.stats_component.health
	for orb in girl.current_orbs:
		if orb != null: current_total_hp += orb.stats_component.health
	var percentage = (current_total_hp * 100)/girl.boss_and_all_orbs_max_hp_sum
	return percentage
