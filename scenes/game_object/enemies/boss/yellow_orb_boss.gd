class_name GirlCultBossOrb extends BasicEnemy

@export var girl : BasicEnemy
var id : float

signal initialized

func init():
	state_machine.on_child_transition("Spin")
	initialized.emit()
