extends TileMap

var worldgen
var moisture_map

func set_maps(worldgen):
	worldgen = worldgen
	moisture_map = worldgen.moisturemap

func set_moisture(worldgen):
	set_maps(worldgen)	
	var y = 0
	for row in moisture_map:
		var x = 0
		for moisture in row:
			if moisture < 20:
				set_cell(x, y, 0)
			elif moisture >= 20 and moisture < 50:
				set_cell(x, y, 1)
			elif moisture >= 50 and moisture < 80:
				set_cell(x, y, 2)
			elif moisture >= 80:
				set_cell(x, y, 3)
			else:
				set_cell(x, y, -1)
			x += 1
		y += 1

