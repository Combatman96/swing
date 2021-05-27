extends KinematicBody2D

var velocity = Vector2.ZERO
var player = null
var was_hit = false
var SPEED = 20
var GRAVITY = 30
var HEALTH = 2
var drop = 0

var coin = preload("res://Scenes/Coin.tscn")
var heart = preload("res://Scenes/Heart.tscn")
var rng = RandomNumberGenerator.new()

var floating_text = preload("res://UI/FloatingText.tscn")

#turn the object
const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1
var direction = Vector2(DIRECTION_RIGHT, 1)

var state_machine = null

	
func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT # default to right if param is 0
	var hor_dir_mod = hor_direction / abs(hor_direction) # get unit direction
	apply_scale(Vector2(hor_dir_mod * direction.x, 1)) # flip
	direction = Vector2(hor_dir_mod, direction.y) # update direction

func _physics_process(delta):
	
	velocity.y += GRAVITY
	
	if player != null and !was_hit :
		velocity.x = position.x - player.position.x
		if velocity.x > 0:
			set_direction(DIRECTION_LEFT)
		elif velocity.x < 0:
			set_direction(DIRECTION_RIGHT)	
		velocity.x = direction.x * SPEED
		if velocity.x != 0:
			state_machine.travel("Run")	
		
	velocity = move_and_slide(velocity)
	velocity.x = lerp(velocity.x, 0, 0.1)


func got_hit():
	var text = floating_text.instance()
	text.amount = 1
	text.direction = direction
	add_child(text)
	SPEED = 0
	was_hit = true
	$Wait.start(1)
	state_machine.travel("Hurt")
	HEALTH -= 1
	if HEALTH <= 0:
		die()
		
func die():
	state_machine.travel("Die")		
	player = null
	$BiteRange.set_collision_layer_bit(7, false)
	$BiteRange.set_collision_mask_bit(0, false)
	$PlayerDetector.set_collision_layer_bit(7, false)
	$PlayerDetector.set_collision_mask_bit(0, false)
	$DeadAwait.start()
	
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

func _on_PlayerDetector_body_entered(body):
	SPEED = 20
	player = body

func _on_PlayerDetector_body_exited(body):
	if !was_hit:
		SPEED = 0
		state_machine.travel("Idle")

func _on_BiteRange_body_entered(body):
	SPEED = 0
	$Wait.start(0.4)
	state_machine.travel("Bite")

func _on_BiteHitBox_body_entered(body):
	if player != null:
		player.got_hurt(direction.x)

func _on_SporeHitbox_body_entered(body):
	if player != null:
		player.got_hurt(direction.x)

func _on_DeadAwait_timeout():
	queue_free()

func _on_Wait_timeout():
	SPEED = 20
	was_hit = false

func _on_SpawnRate_timeout():
	drop = rng.randi_range(0,2)
