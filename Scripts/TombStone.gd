extends Sprite

const Ghost_Resources = preload("res://Scenes/Ghost.tscn")
var Ghost_instance = null

func _ready():
	Ghost_instance = Ghost_Resources.instance()

func _on_PlayerDetectior_body_entered(body):
	add_child(Ghost_instance)


