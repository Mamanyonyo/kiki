class_name GirlCultBossOrb extends BasicEnemy

@export var girl : BasicEnemy
@export var state_machine : StateMachine
var id : float

func init():
	state_machine.on_child_transition("Spin")
