extends ChasePlayer

@onready var timer : Timer = $Timer

func Enter():
	super.Enter()
	timer.start()
	
func Exit():
	super.Exit()
	timer.stop()


func _on_timer_timeout() -> void:
	transitioned.emit("Throwing")
