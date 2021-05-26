extends KinematicBody2D

var velocity = Vector2(0, 0)
export var SPEED  = 200
export var GRAVITY = 30
export var JUMPFORCE = -900

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	
	velocity.y  += GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
		
	velocity = move_and_slide(velocity)
	print(is_on_floor())
	velocity.x = lerp(velocity.x, 0, 0.2)	 
