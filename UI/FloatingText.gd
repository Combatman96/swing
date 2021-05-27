extends Position2D

onready var label = get_node("Label")
onready var tween = get_node("Tween")
var amount = 0

#FLipping the Object and its childrent
const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1
var direction
var facing

func set_direction_old(hor_direction):
	var x = hor_direction.x
	if x == -1:
		apply_scale(Vector2(x, 1)) # flip
		
func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT # default to right if param is 0
	var hor_dir_mod = hor_direction / abs(hor_direction) # get unit direction
	apply_scale(Vector2(hor_dir_mod * direction.x, 1))
	direction = Vector2(hor_dir_mod, direction.y)
	
func set_facing(facing):
	facing = facing

func _ready():
	set_direction_old(direction)
	set_facing(direction.x)
	label.set_text(str(amount))
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position",
		Vector2(0, 0), Vector2(0, -50), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _process(delta):
	if Input.is_action_pressed("right") && facing == -1:
		set_facing(1)
		set_direction(DIRECTION_LEFT)
	if Input.is_action_pressed("left") && facing == 1:
		set_facing(-1)
		set_direction(DIRECTION_RIGHT)

func _on_Tween_tween_completed(object, key):
	self.queue_free()
