extends Node

func _ready():
	$AnimationPlayer.play("idle")

func _on_Coin_body_entered(body):
	body.add_coin()
	queue_free()
