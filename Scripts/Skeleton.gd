extends KinematicBody2D

var velocity = Vector2.ZERO
var SPEED = 30
var GRAVITY  = 30
var distance = 0 
var player = null

var is_attacking = false

onready var projectile_resources = preload("res://Scenes/projectile2.tscn")
var projectile_instance = null
export var can_throw = false
var HEALTH = 3

const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1
var direction = Vector2(DIRECTION_RIGHT, 1)

onready var state_machine =  $AnimationTree.get("parameters/playback")

func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT # default to right if param is 0
	var hor_dir_mod = hor_direction / abs(hor_direction) # get unit direction
	apply_scale(Vector2(hor_dir_mod * direction.x, 1)) # flip
	direction = Vector2(hor_dir_mod, direction.y) # update direction
	
	
func _physics_process(delta):
	
	velocity.y += GRAVITY
	
	if player != null :
		distance = abs(position.x - player.position.x)
		
	if distance > 350: 
		SPEED = 0
		state_machine.travel("Idle")
	elif distance > 220 :
		state_machine.travel("Throw")
		if can_throw:
			throw()
		SPEED = 0
		
	elif distance > 54 and not is_attacking:	
		state_machine.travel("Walk")
		SPEED = 30
		velocity.x = position.x - player.position.x
		if velocity.x > 0:
			set_direction(DIRECTION_LEFT)
		elif velocity.x < 0:
			set_direction(DIRECTION_RIGHT)	
		
		velocity.x = direction.x * SPEED
		
	velocity = move_and_slide(velocity)
	velocity.x = lerp(velocity.x, 0, 0.3)
	

func throw():
	projectile_instance = projectile_resources.instance()
	add_child(projectile_instance)
	projectile_instance.transform = $ProjectileSpawnPoint.transform

func got_hit():
	HEALTH -= 1
	if HEALTH > 0:
		state_machine.travel("Hurt")
	else :
		die()	

func die():
	state_machine.travel("Die")
	player = null
	$HitBox.free()
	$PlayerDetector.free()
	$ShieldBox.free()
	$AttackRange.free()
	$DeadTimer.start()

func _on_PlayerDetector_body_entered(body):
	player = body
	


func _on_AttackRange_body_entered(body):
	state_machine.travel("Shield")
	is_attacking = true
	$RecoveryTimer.start()
	


func _on_RecoveryTimer_timeout():
	is_attacking = false


func _on_HitBox_body_entered(body):
	if player != null:
		 player.got_hurt(direction.x)


func _on_DeadTimer_timeout():
	queue_free()


