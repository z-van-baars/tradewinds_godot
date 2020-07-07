extends Node2D

var name_str = " patheces"

func _ready():
	$WanderTimer.start()

func _process(delta):
	pass

func wander():
	var new_target = Vector2(
		$Ship.position.x + randi()%500 - 250,
		$Ship.position.y + randi() % 500 - 250)
	$Ship.set_target(new_target)


func _on_WanderTimer_timeout():
	wander()
