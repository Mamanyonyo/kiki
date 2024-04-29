class_name GirlCultBossOrb extends BasicEnemy

@export var initial_state : String = "Spin"
@export var girl : UnnamedCultGirlBoss
@export var center : Marker2D
var id : float

signal initialized

func init():
	state_machine.on_child_transition(initial_state)
	initialized.emit()
