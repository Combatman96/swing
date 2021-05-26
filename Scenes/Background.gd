extends Node

onready var goblin = preload("res://Scenes/Goblin.tscn")
onready var SpawnGround = get_node("SpawnPoint/Ground1")

# Called when the node enters the scene tree for the first time.

func _ready():
	print("Spawned Item")
	var goblinSpawn = goblin.instance()
	goblinSpawn.position = SpawnGround.get_global_position()
	add_child(goblinSpawn)
