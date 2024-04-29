extends ChasePlayer

@onready var timer : Timer = $Timer
@export var girl : UnnamedCultGirlBoss

var attacked = false

func Enter():
	super.Enter()
	timer.start()
	
func Update(_delta):
	var current_total_hp = girl.stats_component.health
	for orb in girl.current_orbs:
		if orb != null: current_total_hp += orb.stats_component.health
	var percentage = (current_total_hp * 100)/girl.boss_and_all_orbs_max_hp_sum
	if percentage < 75 && attacked == false:
		attacked = true
		transitioned.emit("Casting")
		return
	super.Update(_delta)
	
func Exit():
	timer.stop()
	super.Exit()


func _on_timer_timeout() -> void:
	transitioned.emit("Throwing")
