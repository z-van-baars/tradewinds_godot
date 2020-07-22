extends Node2D
var width = 0
var height = 0

func set_map_parameters(map_width, map_height):
	width = map_width
	height = map_height

func r_choice(some_array):
	return some_array[randi() % some_array.size()]

func shuffleList(list):
	var shuffledList = []
	var indexList = range(list.size())
	for i in range(list.size()):
		randomize()
		var x = randi()%indexList.size()
		shuffledList.append(list[x])
		indexList.remove(x)
		list.remove(x)
	return shuffledList

func check_distance_above(point_to_check, existing_points, d_threshold):
	# Returns True if any point is within a given range of the point to check
	# Else False
	for point in existing_points:
		if distance(point_to_check.x, point_to_check.y,
					point.x, point.y) < d_threshold:
			return true
	return false


func filter_tiles(tile_list: Array, water=false):
	# Returns a filtered list of tiles excluding either land or water tiles
	var water_tiles = []
	var land_tiles = []
	var biome_map = get_tree().root.get_node("Main/WorldGen/BiomeMap")
	var water_biomes = get_tree().root.get_node("Main/WorldGen/BiomeSelector").water_indexes
	var filtered_tiles = []
	for tile in tile_list:
		if biome_map.get_cellv(tile) in water_biomes:
			water_tiles.append(tile)
		else:
			land_tiles.append(tile)
	if water:
		return water_tiles
	else:
		return land_tiles

func get_neighbor_tiles(tile_address: Vector2):
	var x1 = tile_address.x
	var y1 = tile_address.y
	var all_neighbors = [
		Vector2(x1 - 1, y1 - 1),
		Vector2(x1,     y1 - 1),
		Vector2(x1 + 1, y1 - 1),
		Vector2(x1 - 1, y1),
		Vector2(x1 + 1, y1),
		Vector2(x1 - 1, y1 + 1),
		Vector2(x1,     y1 + 1),
		Vector2(x1 + 1, y1 + 1)]
	var in_map_neighbors = []
	for neighbor in all_neighbors:
		if (neighbor.x < width and
			neighbor.y < width and
			neighbor.x >= 0 and
			neighbor.y >= 0):
				in_map_neighbors.append(neighbor)
	return in_map_neighbors

func get_nearby_tiles(center_tile: Vector2, radius: float, inclusive=false):
	var nearby_tiles: Array = []
	# inclusive means leaving out the center tile if false, including if true
	for y in range(radius * 2):
		for x in range(radius * 2):
			if distance(
				center_tile.x,
				center_tile.y,
				center_tile.x - radius + x,
				center_tile.y - radius + y) <= radius:
				nearby_tiles.append(Vector2(center_tile.x - radius + x,
											center_tile.y - radius + y))
	return nearby_tiles

func cull_duplicates(array: Array):
	var new_dict = {}
	for entry in array:
		new_dict[entry] = null
	return new_dict.keys()

func min_arr(arr: Array):
	# Returns the smallest element of an array
	var min_val = arr[0]
	for i in range(1, arr.size()):
		min_val = min(min_val, arr[i])
	return min_val

func max_arr(arr: Array):
	# Returns the largest element of an array
	var max_val = arr[0]
	for i in range(1, arr.size()):
		max_val = max(max_val, arr[i])
	return max_val

func distance(a1: float, b1: float, x1: float, y1: float):
	# Pythagorean distance between two points, Vector2(a,b) and Vector2(x,y)
	# Returns an unrounded float
	var a2 = abs(a1 - x1)
	var b2 = abs(b1 - y1)
	return sqrt((a2 * a2) + (b2 * b2))
