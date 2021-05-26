extends MarginContainer

func _ready():
	visible = false
	
func _on_Health_health_depleted():
	visible = true
	
func _physics_process(_delta):
	pass

func _on_Try_pressed():
	get_tree().change_scene("res://Scenes/Background.tscn")

func _on_Menu_pressed():
	get_tree().change_scene("res://UI/Menu.tscn")

func _on_Exit_pressed():
	get_tree().quit()
