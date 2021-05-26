extends KinematicBody2D

var player = null


var velocity = Vector2.ZERO 

const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1
var direction = Vector2(DIRECTION_RIGHT, 1)

var state_machine = null
var current_state

export var HEALTH = 3

export var SPEED = 0
var GRAVITY = 30
	
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT # default to right if param is 0
	var hor_dir_mod = hor_direction / abs(hor_direction) # get unit direction
	apply_scale(Vector2(hor_dir_mod * direction.x, 1)) # flip
	direction = Vector2(hor_dir_mod, direction.y) # update direction
	
func _physics_process(delta):
	
	if player != null :
		velocity.x = position.x - player.position.x
		if velocity.x > 0:
			set_direction(DIRECTION_LEFT)
		elif velocity.x < 0:
			set_direction(DIRECTION_RIGHT)	
		velocity.x = direction.x * SPEED
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity)
	velocity.x = lerp(velocity.x, 0, 0.4)
	
	current_state = state_machine.get_current_node()
	#print(current_state)	

func _on_PlayerDetector_body_entered(body):
	player = body
	if current_state == "Idle":
		 state_machine.travel("Dodge")
	elif current_state == "Run":	
		state_machine.travel("StandAttack")
		
		
func got_hit():
	HEALTH -= 1
	if HEALTH > 0:
		state_machine.travel("Hurt")
	else :
		die()
		
func die():
	#print("DEAD")
	state_machine.travel("Die") 			
	$HitBox.set_collision_layer_bit(3, false)
	$PlayerDetector.set_collision_layer_bit(7, false)
	$PlayerDetector.set_collision_mask_bit(0, false)
	set_collision_mask_bit(2, false)
	$DeadAwait.start()
	player = null

func _on_HitBox_body_entered(body):
	if player != null:
		player.got_hurt(direction.x)


func _on_DeadAwait_timeout():
	queue_free()
