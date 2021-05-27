extends Node

func _ready():
	$AnimationPlayer.play("idle")

func _on_Heart_body_entered(body):
	body.get_heart()
	queue_free()
