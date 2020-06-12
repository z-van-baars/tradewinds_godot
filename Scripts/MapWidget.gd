extends TextureRect

var map_width
var map_height
var tilemap_reference
var player


func setup_references(biomemap):
	map_width = biomemap.size()
	map_height = biomemap.size()
	tilemap_reference = get_tree().root.get_node("Main/WorldGen/BiomeMap")
	print(tilemap_reference)
	player = get_tree().root.get_node("Main/Player")

func redraw_minimaps(biomemap):
	var water_color = Color.darkblue
	var land_color = Color.green
	var water_biomes = get_tree().root.get_node("Main/WorldGen/BiomeSelector").water_biomes
	var img = Image.new()
	img.create(
		biomemap.size(),
		biomemap.size(),
		false,
		Image.FORMAT_RGBA8)
	img.lock()
	var x = 0
	var y = 0
	for row in biomemap:
		for tile in row:
			if tile in water_biomes:
				img.set_pixel(x, y, water_color)
			else:
				img.set_pixel(x, y, land_color)
			x += 1
		x = 0
		y += 1
	img.unlock()
	var itex = ImageTexture.new()
	itex.create_from_image(img)
	$LandwaterMinimap.texture = itex
