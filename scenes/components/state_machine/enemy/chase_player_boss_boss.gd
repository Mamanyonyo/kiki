extends ChasePlayer

@onready var timer : Timer = $Timer
@export var girl : UnnamedCultGirlBoss

var attacked = false

func Enter():
	var percentage = get_percentage()
	super.Enter()
	if percentage > 50: timer.start()
	else:
		for orb in girl.current_orbs:
			if orb != null: 
				orb.state_machine.on_child_transition("LockIn")
	
func Update(_delta):
	var percentage = get_percentage()
	if percentage < 75 && attacked == false:
		attacked = true
		transitioned.emit("Casting")
		return
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
