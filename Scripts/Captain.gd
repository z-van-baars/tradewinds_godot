extends Node2D

var name_str = " patheces"
var portrait_id
var captains
var player

var disposition = {}

func _ready():
	$WanderTimer.start()
	captains = get_tree().root.get_node("Main/Captains")
	player = get_tree().root.get_node("Main/Player")

func _process(delta):
	pass

func select_greeting():
	captains.choose_random_greeting(disposition[player])
	
func wander():
	var new_target = Vector2(
		$Ship.position.x + randi()%500 - 250,
		$Ship.position.y + randi() % 500 - 250)
	$Ship.set_target(new_target)

func _on_WanderTimer_timeout():
	wander()
