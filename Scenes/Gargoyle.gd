extends Sprite

var projectile_Resourse = preload("res://Scenes/projectile.tscn")
var projectile_instance = null

var can_fire = true
	
func _process(delta):
	if can_fire:
		projectile_instance = projectile_Resourse.instance()
		add_child(projectile_instance)
		projectile_instance.transform = $ProjectileSpawnPoint.transform
		can_fire = false
		$AttackTimer.start()
	
func _on_AttackTimer_timeout():
	can_fire = true
