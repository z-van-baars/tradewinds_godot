extends Node2D
var tools
var player
var biome_map
var captain_scene = preload("res://Scenes/Captain.tscn")
var ship_scene = preload("res://Ships/Ship.tscn")



func _ready():
	tools = get_tree().root.get_node("Main/Tools")
	player = get_tree().root.get_node("Main/Player")
	biome_map = get_tree().root.get_node("Main/WorldGen/BiomeMap")

		

func generate_random_captains(cities, n_per_city):
	print(cities.size())
	for each in cities:
		var nearby_water_tiles: Array = tools.filter_tiles(tools.get_nearby_tiles(each.map_tile, 5), true)
		if nearby_water_tiles.size() == 0:
			print("skipped a city with 0 water tiles")
		else:
			print("Spawning a Captain")
			for cap in range(n_per_city):
				var random_tile = tools.r_choice(nearby_water_tiles)
				var tile_coords = biome_map.map_to_world(random_tile)
				spawn_captain(tile_coords)

func spawn_captain(world_pos):
	var new_captain = captain_scene.instance()
	add_child(new_captain)
	new_captain.initialize()
	var new_ship = ship_scene.instance()
	new_captain.add_child(new_ship)
	new_ship.position = world_pos
	new_ship.initialize_stats("galleon", false, new_captain)
	new_ship.connect_signals(
		player,
		get_tree().root.get_node("Main/UILayer/InfoCard"),
		get_tree().root.get_node("Main/Dispatcher"),
		new_captain)


