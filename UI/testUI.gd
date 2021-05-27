extends Control

var coin = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthBar/ProgressBar.max_value = 100
	$HealthBar/ProgressBar.value = 100
	$CoinCount/Label.text = str(coin)

func _on_Health_health_change(health):
	$HealthBar/ProgressBar.value = health

func _on_CoinCount_coin_change(coin):
	$CoinCount/Label.text = str(coin)
