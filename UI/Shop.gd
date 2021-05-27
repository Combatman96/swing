extends MarginContainer
onready var hero_scenes = get_node("/root/Background/Hero")

func _ready():
	print(hero_scenes)
	visible = false

func _on_Wave1_timeout():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state


func _on_Wave2_timeout():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state


func _on_Button3_pressed():
	print("choose 3")
	hero_scenes.heal(30)
	get_tree().paused = false
	visible = false


func _on_Button2_pressed():
	print("choose 2")
	hero_scenes.get_money(30)
	get_tree().paused = false
	visible = false


func _on_Button1_pressed():
	print("choose 1")
	hero_scenes.get_money(20)
	get_tree().paused = false
	visible = false
