extends Node2D

var width = 0
var height = 0
var n_cities = 5
var heightmap = []
var tempmap = []
var moisturemap = []
var biomemap = []
var tools
var city_scene = preload("res://Scenes/City.tscn")
var city_tiles = [0, 1]

func set_map_parameters(map_width, map_height, maps):
	width = map_width
	height = map_height
	heightmap = maps[0]
	tempmap = maps[1]
	moisturemap = maps[2]
	biomemap = maps[3]
	tools = get_tree().root.get_node(
		"Main/Tools")

func gen_cities():
	pick_cities(get_coastal_tiles())

func get_coastal_tiles():
	var all_shallows = []
	for y in range(height):
		for x in range(width):
			if biomemap[y][x] == "shallows":
				all_shallows.append(Vector2(x, y))

	var valid_coastal_tiles = []
	for shallow_tile in all_shallows:
		var new_neighbors_raw = tools.get_neighbor_tiles(
			Vector2(shallow_tile.x, shallow_tile.y))
		for tile_addr in new_neighbors_raw:
			var biome_str = biomemap[tile_addr.y][tile_addr.x]
			if (biome_str != "ocean" and
				biome_str != "sea" and
				biome_str != "shallows"):
				valid_coastal_tiles.append(tile_addr)
	return tools.cull_duplicates(valid_coastal_tiles)

func pick_cities(l_coastal_tiles):
	for n in range(n_cities):
		var choice = l_coastal_tiles[randi() % l_coastal_tiles.size()]
		var new_city = city_scene.instance()
		new_city.tile_x = choice.x
		new_city.tile_y = choice.y
		add_child(new_city)
		new_city.initialize()
		new_city.connect_signals(
			get_tree().root.get_node("Main/UILayer/CityLabel"),
			get_tree().root.get_node("Main/UILayer/CityMenu"),
			get_tree().root.get_node("Main/UILayer/MarketMenu"))
		get_tree().root.get_node("Main/WorldGen/CityMap").set_cell(
			new_city.tile_x,
			new_city.tile_y,
			tools.r_choice(city_tiles))
