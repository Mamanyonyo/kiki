class_name StatsComponent extends Node

@export var max_damage : float = 3
@export var max_magic_damage : float = 7
@export var max_speed : float = 1
@export var max_health : float = 15
@export var max_resistance : float = 1
@export var max_mana : float = 1
@export var max_mana_reg : float = 1
@export var max_stamina : float = 1

var damage : float
var magic_damage : float
var speed : float
var health : float
var resistance : float
var mana : float
var mana_reg : float
var stamina : float

func _ready():
	damage = max_damage
	magic_damage = max_magic_damage
	speed = max_speed
	health = max_health
	resistance = max_resistance
	mana = max_mana
	mana_reg = max_mana_reg
	stamina = max_stamina
	
func stat_up(name, amount):
	self[name] += amount
	self["max_" + name] += amount
