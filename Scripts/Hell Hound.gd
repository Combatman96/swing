extends KinematicBody2D

export var SPEED = 80
export var GRAVITY = 220
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var playerDetected = false

func _ready():
	$AnimatedSprite.play("Idle")

func _physics_process(delta):
	velocity.y =+ GRAVITY
	
	#move and animation
	if playerDetected:
		$AnimatedSprite.play("Run")
		velocity.x = -direction.x * SPEED
		$AnimatedSprite.scale = direction
		
	#print(scale)
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_PlayerDetection_body_entered(body):
	playerDetected = true
	if body.position.x - position.x > 0 :
		direction = Vector2(-1,1)
	else :
		direction = Vector2(1,1)	

func got_hit():
	playerDetected = false
	print("HIT!")
	$AnimatedSprite.play("Die")
	#knock backward
	velocity.x = direction.x * 400
	GRAVITY = -400
	$DeathAwait.start()
	#fall to hell


func _on_HitBox_body_entered(body):
	body.got_hurt(-direction.x)


func _on_DeathAwait_timeout():
	queue_free()
