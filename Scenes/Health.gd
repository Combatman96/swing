extends Node2D

signal health_change(health)
signal health_depleted

var health = 0
export(int) var max_health = 100
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	emit_signal("health_change", health)
	pass # Replace with function body.

func take_damage(amount):
	health -= amount
	health = max(0, health)
	if (health <= 0):
		emit_signal("health_depleted")
	emit_signal("health_change", health)
	
func get_heart():
	var amount = rng.randi_range(5, 10)
	health += amount
	if (health > max_health):
		health = max_health
	emit_signal("health_change", health)

func heal(amount):
	health += amount
	health = max(health, max_health)
	if (health > max_health):
		health = max_health
	emit_signal("health_change", health)
