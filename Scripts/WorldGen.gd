extends Node
var width
var height
var heightmap = []
var tempmap = []
var moisturemap = []
var biomemap = []
var rivermap = []
var river_seeds = []
var river_start_candidates = []
var river_start_height_cutoff = 0.60
var n_rivers
var rivers = []

var tools
var cities


var noise = OpenSimplexNoise.new()

func _ready():
	tools = get_tree().root.get_node("Main/Tools")
	cities = get_tree().root.get_node("Main/Cities")
	# Configure
	randomize()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8


func gen_new(w=100, h=100):
	width = w
	height = h
	tools.set_map_parameters(width, height)
	
	$BiomeMap.clear()
	$TempMap.clear()
	$MoistureMap.clear()
	generate_heightmap()
	generate_tempmap()
	generate_moisturemap()
	n_rivers = int(sqrt((width + height) / 2))
	run_rivers()
	$RiverLayer.rivers = rivers
	set_biomes()
	$TempMap.set_temp(self)
	$MoistureMap.set_moisture(self)
	$BiomeMap.set_biome_type(self)
	draw_rivers()
	var map_arr_list = [
		heightmap,
		tempmap,
		moisturemap,
		biomemap]
	cities.set_map_parameters(
		width, height, map_arr_list)
	cities.gen_cities()
	# $PreviewContainer.set_dims(width, height)
	# $PreviewContainer.heightmap_preview(heightmap)
	get_tree().root.get_node("Main/UILayer/LoadSplash").hide()

func draw_rivers():
	for y in range(height):
		for x in range(width):
			if rivermap[y][x][0] == true:
				$VegetationMap.set_cell(x, y, 3)

func get_noise(nx, ny):
	# rescale from -1.0:+1/0 to 0.0:1.0
	# aka normalize
	return noise.get_noise_2d(nx, ny) / 2.0 + 0.5

func generate_heightmap():
	# higher value means more land but also chance of edge touching
	var a = 0.05
	# pushes the edges farther down
	var b = 0.25
	# how quick the elevation falloff is toward the edges
	var c = 10.00
	for y in range(height):
		var row = []
		for x in range(width):
			var nx = (float(x) / float(width)) - 0.5
			var ny = (float(y) / float(height)) - 0.5
			# Manhattan Distance from edges - don't like
			# d = 2 * max(abs(nx), abs(ny))
			# Euclidian Distance from edges
			var d = 2 * sqrt(nx * nx + ny * ny)
			# print("%s, %s", [nx, ny])
			# print(d)
			# crunchify the noise by adding higher frequency noise
			# reduces banding and round edges / softness
			var rand_height_1 = 1.00 * get_noise(96 * nx, 96 * ny)
			rand_height_1 += 0.35 * get_noise(128 * nx, 128 * ny)
			rand_height_1 += 0.25 * get_noise(256 * nx, 256 * ny)
			# normalize the value, previous function produces large values
			var rand_height_2 = rand_height_1 / (1.0 + 0.35 + 0.25)
			# add in the egde disincentive
			var rand_height_edge_biased = rand_height_2 + a - b * pow(d, c)
			var rand_height_final = max(0, rand_height_edge_biased)
			if rand_height_final > river_start_height_cutoff:
				print(rand_height_final)
				river_start_candidates.append(Vector2(x, y))
			row.append(rand_height_final)
		heightmap.append(row)

func get_temperature(x, y, pole_distances):
	"""modified perlin noise generator
	resulting values are normalized into temp """
	var map_hotness = 80
	var equator_hotness = 0.5
	var pole_coldness = 1.0
	var noise_strength = 1.5
	var nx = (float(x) / float(width)) - 0.5
	var ny = (float(y) / float(height)) - 0.5
	var temp1 = (noise_strength * get_noise(32 * nx, 32 * ny))
	var max_dist = sqrt(width * height) / 2
	var dist_mod = (pole_distances[y][x] / max_dist) * 2
	var temp2 = (0.5 +
		dist_mod *
		equator_hotness -
		dist_mod *
		pole_coldness)
	var temp3 = temp2 + temp1
	var temp4 = max(temp3, 0) * map_hotness
	var temp5 = min(temp4, 100)
	if temp5 < 0:
		print(temp5)
	return temp5
func check_distance(point_to_check, existing_points, d_threshold):
	# Returns True if any point is within a given range of the point to check
	# Else False
	for point in existing_points:
		if tools.distance(point_to_check.x, point_to_check.y,
						  point.x, point.y) > d_threshold:
			return true
	return false
		
func choose_river_seeds():
	var shuffled_seeds = tools.shuffleList(river_start_candidates)
	var set_seeds = []
	print(shuffled_seeds)
	print("Number of rivers: " + str(n_rivers))
	for r in range(n_rivers):
		var chosen = false
		while chosen == false:
			var start_point = shuffled_seeds[0]
			if check_distance(start_point, set_seeds, n_rivers) == false:
				set_seeds.append(start_point)
				chosen = true
			shuffled_seeds.erase(start_point)
	return set_seeds

func init_rivermap():
	for y in range(height):
		var row = []
		for x in range(width):
			row.append([false, [], null])
		rivermap.append(row)

func find_flowpoint(start_tile):
	var neighbors = tools.get_neighbor_tiles(start_tile)
	var lowest_neighbor = [999999, Vector2.ZERO]
	
	for neighbor in neighbors:
		if heightmap[neighbor.y][neighbor.x] < lowest_neighbor[0]:
			lowest_neighbor = [heightmap[neighbor.y][neighbor.x], neighbor]
	return lowest_neighbor[1]

func mark_flowpoint(start_tile, flowpoint):
	var start_sources = rivermap[start_tile.y][start_tile.x][1]
	rivermap[start_tile.y][start_tile.x] = [
		true,
		start_sources,
		flowpoint]
	var flowpoint_sources = rivermap[flowpoint.y][flowpoint.y][1]
	flowpoint_sources.append(start_tile)
	rivermap[flowpoint.y][flowpoint.x] = [
		true,
		flowpoint_sources,
		null]

func run_rivers():
	print("Running rivers...")
	init_rivermap()
	print("Finding river seeds...")
	var river_seeds = choose_river_seeds()
	print(river_seeds)
	for river_seed in river_seeds:
		var new_river = []

		print("Running a river...")
		var river_length = 0
		var flowing = true
		var active_tile = river_seed
		rivermap[active_tile.y][active_tile.x] = [true, [], null]
		print(active_tile.x)
		while flowing:
			var coord_pair = $BiomeMap.map_to_world(Vector2(active_tile.x, active_tile.y))
			new_river.append(Vector2(coord_pair.x, coord_pair.y - 58))
			river_length += 1
			var flowpoint = find_flowpoint(active_tile)
			if (rivermap[flowpoint.y][flowpoint.x][0] == true
				or heightmap[flowpoint.y][flowpoint.x] <= 0.55):
				flowing = false
			mark_flowpoint(active_tile, flowpoint)
			active_tile = flowpoint
		print("... done, length - " + str(river_length))
		rivers.append(new_river)

	
		
func set_pole_distances():
	var npoints = int(sqrt(sqrt(width * height)))
	var slope = Vector2(width / npoints, height / npoints)
	var xx = 0
	var yy = height
	var equator = [Vector2(xx, yy)]
	for e in range(npoints + 2):
		xx += slope[0]
		yy -= slope[1]
		equator.append(Vector2(int(xx), int(yy)))

	var pole_distances = []
	for y in range(height):
		pole_distances.append([])
		for x in range(width):
			# north_pole = utilities.distance(0, 0, x, y)
			# south_pole = utilities.distance(width, height, x, y)
			var eq_distances = []
			for each in equator:
				eq_distances.append(tools.distance(each[0], each[1], x, y))
			# equatorial_distance = min(north_pole, south_pole)
			var eq_distance = tools.min_arr(eq_distances)
			pole_distances[y].append(floor(eq_distance))
	return pole_distances

func generate_tempmap():
	var pole_distances = set_pole_distances()
	for y in range(height):
		var row = []
		for x in range(width):
			var new_temp = get_temperature(x, y, pole_distances)
			row.append(round(new_temp))
		tempmap.append(row)

func generate_moisturemap():
	var water_cutoff = 0.55
	for y in range(height):
		var row = []
		for x in range(width):
			var nx = float(x) / float(width) - 0.5
			var ny = float(y) / float(height) - 0.5
			var moisture_1 = (1.0 * get_noise(48 * nx, 48 * ny))
			var moisture_2 = moisture_1 / (1.0)
			var moisture_3 = 0
			if heightmap[y][x] <= water_cutoff:
				moisture_3 = 100
			else:
				moisture_3 = min(100, moisture_2 * 100)
			row.append(floor(moisture_3))
		moisturemap.append(row)

func set_biomes():
	for y in range(height):
		var row = []
		for x in range(width):
			var str_biome = $BiomeSelector.get_biome(
				tempmap[y][x], moisturemap[y][x])
			if heightmap[y][x] > 0.55:
				row.append(str_biome)
			elif 0.55 >= heightmap[y][x] and heightmap[y][x] > 0.50:
				row.append("shallows")
			elif 0.50 >= heightmap[y][x] and heightmap[y][x] > 0.45:
				row.append("sea")
			elif 0.45 >= heightmap[y][x]:
				row.append("ocean")
		biomemap.append(row)
	print(" ")
	print("Set all biomes...")

