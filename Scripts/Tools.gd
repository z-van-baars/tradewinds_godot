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


func filter_tiles(tile_list, water=false):
	var water_tiles = []
	var land_tiles = []
	var biome_map = get_tree().root.get_node("Main/WorldGen/BiomeMap")
	var water_biomes = get_tree().root.get_node("Main/WorldGen/BiomeSelector").water_biomes
	var filtered_tiles = []
	for tile in tile_list:
		if biome_map.get_cellv(Vector2(tile.x, tile.y)) in water_biomes:
			water_tiles.append(tile)
		else:
			land_tiles.append(tile)
	if water:
		return water_tiles
	else:
		return land_tiles
func get_neighbor_tiles(tile_address):
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

func cull_duplicates(array):
	var new_dict = {}
	for entry in array:
		new_dict[entry] = null
	return new_dict.keys()

func min_arr(arr):
	var min_val = arr[0]
	for i in range(1, arr.size()):
		min_val = min(min_val, arr[i])
	return min_val

func distance(a1, b1, x1, y1):
	var a2 = abs(a1 - x1)
	var b2 = abs(b1 - y1)
	return sqrt((a2 * a2) + (b2 * b2))
