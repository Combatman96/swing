extends KinematicBody2D

var velocity = Vector2.ZERO
export var SPEED  = 200
export var GRAVITY = 30
export var JUMPFORCE = 100
var can_attack = false
var is_hurt = false
var is_dashing = false
var can_dash = false
var state_machine

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

#FLipping the Object and its childrent
const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1
var direction = Vector2(DIRECTION_RIGHT, 1)


func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT # default to right if param is 0
	var hor_dir_mod = hor_direction / abs(hor_direction) # get unit direction
	apply_scale(Vector2(hor_dir_mod * direction.x, 1)) # flip
	direction = Vector2(hor_dir_mod, direction.y) # update direction


func handle_input():
	#var current = state_machine.get_current_node()
	if Input.is_action_just_pressed("attack") and is_on_floor() and is_hurt == false:
		#can_attack = true
		state_machine.travel("Attack")
		can_attack = true
		$AttackTimer.start()
		return
	elif Input.is_action_pressed("right") and can_attack == false and is_hurt == false :
		velocity.x = SPEED
		set_direction(DIRECTION_RIGHT)
		if is_on_floor():
			state_machine.travel("Run")
	elif Input.is_action_pressed("left")  and can_attack == false and is_hurt == false:
		velocity.x = -SPEED
		set_direction(DIRECTION_LEFT)
		if is_on_floor():
			state_machine.travel("Run")				
	elif is_hurt == false: 
		state_machine.travel("Idle")
		
	if Input.is_action_just_pressed("attack") and !is_on_floor() and is_hurt == false:
		state_machine.travel("Air Attack")	
	elif Input.is_action_just_pressed("jump") and is_on_floor() and is_hurt == false:
		velocity.y = -JUMPFORCE
		state_machine.travel("Jump")	
	elif velocity.y > 1 and is_hurt == false :
		state_machine.travel("Fall")	

	if Input.is_action_just_pressed("dash") and can_dash == false and is_hurt == false:
		print("dashing")
		is_dashing = true
		SPEED = 800
		state_machine.travel("Run")
		can_dash = true
		$Timer.start()
		return

func _physics_process(delta):
	handle_input()	
	velocity.y  += GRAVITY	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.5)	
	#print(can_attack)

func got_hurt(var backward):
	print("OUCH!!")
	is_hurt = true
	#health -1
	$Health.take_damage(10)
	if $Health.health <= 0:
		die()
	#play the animation
	else: 
		$StunTimer.start()
		#get incvincibliey for a while
		$InvinciblityTimer.start()
	
	state_machine.travel("Hurt")
	$FX1/Play1.play("FX1")
	
	#knock backward
	velocity.x = backward * 800
	velocity.y = -JUMPFORCE * 0.5
	
	set_collision_mask_bit(8, false)
	set_collision_mask_bit(3, false)


func die():
	print("This is how I die.")
	#let it all go
	GRAVITY = 0
	JUMPFORCE = 0
	SPEED = 0 
	#set_collision_mask_bit(1, false)
	set_collision_layer_bit(0,false)
	set_collision_mask_bit(3, false)
	set_collision_mask_bit(8, false)
	#the death animation
	$hero_full_sheet.hide()
	$AnimatedSprite.play("Die")

func _on_AttackTimer_timeout():
	can_attack = false


func _on_HitBox_body_entered(body):
	body.got_hit()
	#play the hit incdicator
	$FX2/Play2.play("FX2") 


func _on_StunTimer_timeout():
	is_hurt = false


func _on_InvinciblityTimer_timeout():
	print("Invincible OVER")
	set_collision_mask_bit(3, true)
	set_collision_mask_bit(8, true)
	
func _on_Timer_timeout():
	can_dash = false
	$DashTimer.start() 
	is_dashing = false  
	SPEED = 200

#FOR THE GAP BETWEEN DASHES
func _on_DashTimer_timeout():
	can_dash = true
