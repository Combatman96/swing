extends Node

var rng = RandomNumberGenerator.new()
onready var goblin = preload("res://Scenes/Goblin.tscn")
onready var ghost = preload("res://Scenes/Ghost.tscn")
onready var flyingEye = preload("res://Scenes/FyingEye.tscn")
onready var mushroom = preload("res://Scenes/Mushroom.tscn")
onready var hellhound = preload("res://Scenes/HellHound.tscn")
onready var SpawnGround = get_node("SpawnPoint")
# Called when the node enters the scene tree for the first time.

func spawn_sky(enemySpawn):
	var i = rng.randi_range(0, 5)
	var area = rng.randi_range(-50, 50)
	var areay = rng.randi_range(-50, 0)
	var SpawnPoint = SpawnGround.get_children()[i]
	enemySpawn.position.x = SpawnPoint.get_global_position().x + area
	enemySpawn.position.y = SpawnPoint.get_global_position().y + areay
	add_child(enemySpawn)
	
func spawn_ground(enemySpawn):
	var i = rng.randi_range(6, 9)
	var area = rng.randi_range(-50, 50)
	var SpawnPoint = SpawnGround.get_children()[i]
	enemySpawn.position.x = SpawnPoint.get_global_position().x + area
	enemySpawn.position.y = SpawnPoint.get_global_position().y
	add_child(enemySpawn)

func _ready():
	$GoblinSpawn.start()
	$GhostSpawn.start()
	$Wave1.start()

func _on_GoblinSpawn_timeout():
	var enemySpawn = goblin.instance()
	spawn_sky(enemySpawn)
	$GoblinSpawn.start()

func _on_GhostSpawn_timeout():
	var enemySpawn = ghost.instance()
	spawn_ground(enemySpawn)
	$GhostSpawn.start()

func _on_FyingEye_timeout():
	var enemySpawn = flyingEye.instance()
	spawn_sky(enemySpawn)
	$FyingEyeSpawn.start()

func _on_MushroomSpawn_timeout():
	var enemySpawn = mushroom.instance()
	spawn_sky(enemySpawn)
	$MushroomSpawn.start()

func _on_HellSoundSpawn_timeout():
	var enemySpawn = hellhound.instance()
	spawn_ground(enemySpawn)
	$HellSoundSpawn.start()

func _on_Wave1_timeout():
	$GoblinSpawn.stop()
	$MushroomSpawn.start()
	$FyingEyeSpawn.start()
	$Wave2.start()
	$Wave1.stop()

func _on_Wave2_timeout():
	$GhostSpawn.stop()
	$FyingEyeSpawn.stop()
	$HellSoundSpawn.start()
