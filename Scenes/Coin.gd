extends Node2D

signal coin_change(coin)
signal health_depleted

var coin = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("coin_change", 0)
	pass # Replace with function body.

func get_money(amount):
	coin += amount
	print(coin)
	emit_signal("coin_change", coin)
