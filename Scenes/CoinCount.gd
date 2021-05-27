extends Node2D

signal coin_change(coin)

var coin = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("start count money")
	emit_signal("coin_change", coin)
	pass # Replace with function body.

func get_money(amount):
	coin += amount
	print("choose money ", coin, " ", amount)
	emit_signal("coin_change", coin)

func add_coin():
	coin += rng.randi_range(2, 5)
	emit_signal("coin_change", coin)
