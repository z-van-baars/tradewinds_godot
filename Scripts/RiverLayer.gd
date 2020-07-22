extends Node2D
var tools: Node
var biome_map: Node
var width: int
var height: int
var heightmap: Array
var n_rivers: int
var rivermap: Array = []
var rivers: Array = []
var river_start_height_cutoff = 0.605

func _ready():
	tools = get_tree().root.get_node("Main/Tools")
	biome_map = get_tree().root.get_node("Main/WorldGen/BiomeMap")

func _process(delta):
	position = biome_map.position
	update()

func _draw():
	for river in rivers:
		draw_river(river)
	
func draw_river(river_pts: Array):
	draw_polyline(river_pts, Color.blue, 15)


func choose_river_seeds(river_start_candidates: Array, n_rivers: int):
	var shuffled_seeds: Array = tools.shuffleList(river_start_candidates)
	var set_seeds: Array = []
	var re_shuffled_seeds: Array = tools.shuffleList(shuffled_seeds)
	for r in range(n_rivers):
		var chosen: bool = false
		while chosen == false:
			var start_point: Vector2 = tools.r_choice(re_shuffled_seeds)
			if tools.check_distance_above(start_point, set_seeds, n_rivers) == false:
				set_seeds.append(start_point)
				chosen = true
			re_shuffled_seeds.erase(start_point)
	return set_seeds

func init_rivermap():
	var river_start_candidates: Array
	for y in range(height):
		var row: Array = []
		for x in range(width):
			row.append([false, [], null])
			if heightmap[y][x] > river_start_height_cutoff:
				river_start_candidates.append(Vector2(x, y))
		rivermap.append(row)
	return river_start_candidates

func find_flowpoint(start_tile: Vector2):
	var neighbors: Array = tools.get_neighbor_tiles(start_tile)
	var lowest_neighbor: Array = [999999, Vector2.ZERO]
	
	for neighbor in neighbors:
		if heightmap[neighbor.y][neighbor.x] < lowest_neighbor[0]:
			lowest_neighbor = [heightmap[neighbor.y][neighbor.x], neighbor]
	return lowest_neighbor[1]


func mark_flowpoint(start_tile: Vector2, flowpoint: Vector2):
	var start_sources: Array = rivermap[start_tile.y][start_tile.x][1]
	rivermap[start_tile.y][start_tile.x] = [
		true,
		start_sources,
		flowpoint]
	var flowpoint_sources: Array = rivermap[flowpoint.y][flowpoint.y][1]
	flowpoint_sources.append(start_tile)
	rivermap[flowpoint.y][flowpoint.x] = [
		true,
		flowpoint_sources,
		null]

func run_rivers():
	
	print("Running rivers...")
	width = get_tree().root.get_node("Main/WorldGen").width
	height = get_tree().root.get_node("Main/WorldGen").height
	heightmap = get_tree().root.get_node("Main/WorldGen").heightmap
	var river_start_candidates: Array = init_rivermap()
	print("Tiles above cutoff " + str(river_start_height_cutoff) + " : " + str(river_start_candidates.size()))
	n_rivers = int(sqrt((width + height)))
	var river_seeds = choose_river_seeds(river_start_candidates, n_rivers)
	for river_seed in river_seeds:
		var new_river = []
		var river_length = 0
		var flowing = true
		var active_tile = river_seed
		rivermap[active_tile.y][active_tile.x] = [true, [], null]
		var coord_pair = biome_map.map_to_world(Vector2(active_tile.x, active_tile.y))
		new_river.append(Vector2(coord_pair.x, coord_pair.y + 32))
		while flowing:

			river_length += 1
			var flowpoint = find_flowpoint(active_tile)
			if (rivermap[flowpoint.y][flowpoint.x][0] == true
				or heightmap[flowpoint.y][flowpoint.x] <= 0.55):
				flowing = false
			mark_flowpoint(active_tile, flowpoint)
			active_tile = flowpoint
			coord_pair = biome_map.map_to_world(Vector2(active_tile.x, active_tile.y))
			new_river.append(Vector2(coord_pair.x, coord_pair.y + 32))
		if river_length > 1:
			rivers.append(new_river)
	return rivermap
