class_name PlayerStatsComponent extends StatsComponent

@export var max_mana : float = 1
@export var max_mana_reg : float = 1
@export var max_stamina : float = 1
@export var max_drive: float = 100

var mana: float
var mana_reg: float
var stamina: float
var drive: float

func _ready():
	super._ready()
	mana = max_mana
	mana_reg = max_mana_reg
	stamina = max_stamina
	drive = 0
