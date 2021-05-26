extends Node

const ghostResource = preload("res://Scenes/Ghost.tscn")
var ghost_instance = null

func _ready():
	ghost_instance = ghostResource.instance()

func _on_PlayerDetectior_body_entered(body):
	add_child(ghost_instance)
