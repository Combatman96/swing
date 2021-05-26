extends Area2D

onready var state_machine = $AnimationTree.get("parameters/playback")
var player = null

export var speed = 120

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_projectile_body_entered(body):
	if body.name == "Hero":
		var direction = Vector2.ZERO
		direction = get_global_position()
		direction -= body.get_global_position()
		direction.normalized()
		if direction.x > 0: 
			direction.x = 1
		elif direction.x < 0:
			direction.x = -1	  
		body.got_hurt(-direction.x)
	
	state_machine.travel("Collie")
	speed = 0
	$Timer.start()	


func _on_Timer_timeout():
	queue_free()

