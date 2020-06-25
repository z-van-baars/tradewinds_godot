extends Node2D
var captain_scene = preload("res://Scenes/Captain.tscn")
var ship_scene = preload("res://Ships/Ship.tscn")
var player

func _ready():
	player = get_tree().root.get_node("Main/Player")

func spawn_captain(world_pos):
	var new_captain = captain_scene.instance()
	add_child(new_captain)
	var new_ship = ship_scene.instance()
	new_captain.add_child(new_ship)
	new_ship.position = world_pos
	new_ship.initialize_stats("galleon")
	new_ship.connect_signals(
		player,
		get_tree().root.get_node("Main/UILayer/InfoCard"))

