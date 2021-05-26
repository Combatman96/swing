extends KinematicBody2D

var velocity = Vector2.ZERO
var player = null
var was_hit = false
var SPEED = 40 

#turn the object
const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1
var direction = Vector2(DIRECTION_RIGHT, 1)

var state_machine = null

func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT # default to right if param is 0
	var hor_dir_mod = hor_direction / abs(hor_direction) # get unit direction
	apply_scale(Vector2(hor_dir_mod * direction.x, 1)) # flip
	direction = Vector2(hor_dir_mod, direction.y) # update direction

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	if player != null :
		velocity = get_global_position().direction_to(player.get_global_position())
		if velocity.x > 0:
			set_direction(DIRECTION_LEFT)
		elif velocity.x < 0:
			set_direction(DIRECTION_RIGHT)	
		velocity = velocity.normalized() * SPEED
		
	velocity = move_and_slide(velocity)
	velocity.x = lerp(velocity.x, 0, 0.1)

func _on_PlayerDetector_body_entered(body):
	print ("Player detected")
	player = body
	state_machine.travel("Scare")

func _on_HitBox_body_entered(body):
	player.got_hurt(-direction.x)

func _on_PlayerDetector_body_exited(body):
	if !was_hit:
		state_machine.travel("Booing")

func got_hit():
	player = null
	was_hit = true
	SPEED = 0
	state_machine.travel("Gone")
	set_collision_mask_bit(2, false)
	$PlayerDetector.free()
	$HitBox.free()
	$TimeToGo.start()


func _on_TimeToGo_timeout():
	queue_free()



