extends Node2D
var width = 0
var height = 0

func set_map_parameters(map_width, map_height):
	width = map_width
	height = map_height

func r_choice(some_array):
	return some_array[randi() % some_array.size()]

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
