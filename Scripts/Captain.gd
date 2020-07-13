extends "res://Scripts/Character.gd"
var captains

func _ready():
	._ready()
	$WanderTimer.start()
	captains = get_tree().root.get_node("Main/Captains")
	
func wander():
	var new_target = Vector2(
		$Ship.position.x + randi()%500 - 250,
		$Ship.position.y + randi() % 500 - 250)
	$Ship.set_target(new_target)

func _on_WanderTimer_timeout():
	wander()
