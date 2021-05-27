extends KinematicBody2D

export var SPEED = 20
var velocity = Vector2.ZERO
var player = null

const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1
var direction = Vector2(DIRECTION_RIGHT, 1)

export var is_launching = false
var state_machine


func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

#FLipping the Object and its childrent
func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT # default to right if param is 0
	var hor_dir_mod = hor_direction / abs(hor_direction) # get unit direction
	apply_scale(Vector2(hor_dir_mod * direction.x, 1)) # flip
	direction = Vector2(hor_dir_mod, direction.y) # update direction



func _physics_process(delta):
	
	if player != null and is_launching == false:
		velocity = position.direction_to(player.position) 
		if velocity.x > 0:
			set_direction(DIRECTION_RIGHT)
		elif velocity.x < 0:
			set_direction(DIRECTION_LEFT)	
		velocity = velocity.normalized() * SPEED
	elif is_launching == true:
		velocity = Vector2(direction.x * 200, 0) 
		
	if is_on_floor():
		state_machine.travel("HitGround")
		#set_collision_layer_bit(1, false)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.1)

	
func got_hit():
	
	print("HIT!")
	state_machine.travel("Hurt")
	player = null
	#fall to ground
	velocity = Vector2(0, 220)
	set_collision_mask_bit(2, false)
	$DeadAwait.start()
	
func _on_Radar_body_entered(body):
	player = body
	get_node("Radar/DetectionZone").free()
	$Lauch_radar/LauchPoint.disabled = false
	$Attack_radar/AttackPoint.disabled = false

#init attack
func _on_Attack_radar_body_entered(body):
	state_machine.travel("Bite")
	
func _on_Lauch_radar_body_entered(body):
	state_machine.travel("Launch")
	

func _on_HitBox_body_entered(body):
	if player != null:
		player.got_hurt(direction.x)

func _on_DeadAwait_timeout():
	queue_free()
