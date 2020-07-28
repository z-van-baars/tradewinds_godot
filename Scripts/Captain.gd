extends "res://Scripts/Character.gd"
var captains
var home_city
var state = "Idle"

func _ready():
	._ready()
	$WanderTimer.start()
	captains = get_tree().root.get_node("Main/Captains")

func _process(delta):
	$Ship.state = state
	
func wander():
	var new_target = Vector2(
		$Ship.position.x + randi()%500 - 250,
		$Ship.position.y + randi() % 500 - 250)
	$Ship.set_target(new_target)

func _on_WanderTimer_timeout():
	state = "Wander"
	wander()
	$WanderTimer.stop()
	$CityTimer.start()



func _on_CityTimer_timeout():
	state = "Move"
	$CityTimer.stop()
	var r_city = tools.r_choice(get_tree().root.get_node("Main/Cities").get_children())
	$Ship.set_target(
		get_tree().root.get_node("Main/WorldGen/BiomeMap").map_to_world(r_city.map_tile))
	$Ship.destination_city = r_city

func _on_Ship_destination_reached(destination_city):
	state = "Idle"
	if randi()%100 < 30:
		$WanderTimer.wait_time = randi()%10
		$WanderTimer.start()
	else:
		$CityTimer.start()
