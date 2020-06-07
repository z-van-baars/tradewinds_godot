extends TileMap
var worldgen
var temp_map

func set_maps(worldgen):
	worldgen = worldgen
	temp_map = worldgen.tempmap

func set_temp(worldgen):
	set_maps(worldgen)
	var y = 0
	for row in temp_map:
		var x = 0
		for temp in row:
			if temp < 20:
				set_cell(x, y, 4)
			elif temp >= 20 and temp < 40:
				set_cell(x, y, 0)
			elif temp >= 40 and temp < 60:
				set_cell(x, y, 3)
			elif temp >= 60 and temp < 85:
				set_cell(x, y, 2)
			else:
				set_cell(x, y, 1)
			x += 1
		y += 1

