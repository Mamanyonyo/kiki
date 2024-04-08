extends Node2D

@onready var enter = $Enter
@onready var spinner = $Spinner

func _ready():
	enter.play("enter")
