extends KinematicBody2D

var coin = preload("res://Scenes/Coin.tscn")
var heart = preload("res://Scenes/Heart.tscn")
var rng = RandomNumberGenerator.new()

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

var drop = 0
var floating_text = preload("res://UI/FloatingText.tscn")
	
func _ready():
	$SpawnRate.start()
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
	var text = floating_text.instance()
	text.amount = 1
	text.direction = direction
	add_child(text)
	HEALTH -= 1
	if HEALTH > 0:
		state_machine.travel("Hurt")
	else :
		die()
		
func die():
	state_machine.travel("Die") 			
	$HitBox.set_collision_layer_bit(3, false)
	$PlayerDetector.set_collision_layer_bit(7, false)
	$PlayerDetector.set_collision_mask_bit(0, false)
	set_collision_mask_bit(2, false)
	$DeadAwait.start()
	player = null
	_get_drop()
		
func _get_drop():
	if(drop == 0):
		print("coin drop")
		var coinSpawn = coin.instance()
		coinSpawn.global_position = global_position
		get_tree().get_root().add_child(coinSpawn)
	if(drop == 1):
		print("heart drop")
		var heartSpawn = heart.instance()
		heartSpawn.global_position = global_position
		get_tree().get_root().add_child(heartSpawn)

func _on_HitBox_body_entered(body):
	if player != null:
		player.got_hurt(direction.x)

func _on_DeadAwait_timeout():
	queue_free()

func _on_SpawnRate_timeout():
	drop = rng.randi_range(0, 2)
