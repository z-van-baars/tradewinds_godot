extends TileMap
var worldgen
var biomemap
var tools

var biome_tiles = {
	"alpine": [0, 1, 2, 3],
	"conifer": [4, 5, 6, 7],
	"desert": [8, 9, 10, 11],
	"forest": [12, 13, 14, 15],
	"grassland": [16, 17, 18, 19],
	"jungle": [20, 21, 22, 23],
	"lake": [24, 25, 26, 27],
	"ocean": [28, 29, 30, 31],
	"plains": [32, 33, 34, 35],
	"savannah": [60, 61, 62, 63],
	"sea": [36, 37, 38, 39],
	"shallows": [40, 41, 42, 43],
	"snowpack": [44, 45, 46, 47],
	"snowy tundra": [48, 49, 50, 51],
	"taiga": [52, 53, 54, 55],
	"tundra": [56, 57, 58, 59]}
	




func set_maps(worldgen):
	tools = get_tree().root.get_node("Main/Tools")
	worldgen = worldgen
	biomemap = worldgen.biomemap

func set_biome_type(worldgen):
	set_maps(worldgen)
	var y = 0
	for row in biomemap:
		var x = 0
		for str_biome in row:
			var tile_id = tools.r_choice(
				biome_tiles[str_biome])
			set_cell(x, y, tile_id)
			x += 1
		y += 1
