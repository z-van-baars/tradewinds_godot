extends Node2D

var img_width
var img_height

func set_dims(width, height):
	img_width = width
	img_height = height

func heightmap_preview(heightmap):
	var h_img = Image.new()
	h_img.create(img_width, img_height, false, Image.FORMAT_RGBA8)
	h_img.lock()
	var land = Color(0, 200, 0)
	var water = Color(0, 0, 200)
	var y = 0
	for row in heightmap:
		var x = 0
		for height_val in row:
			if height_val > 0.55:
				h_img.set_pixel(x, y, land)
			else:
				h_img.set_pixel(x, y, water)
			x += 1
		y += 1
		var h_preview_sprite = get_tree().root.get_node(
			"Main/Ship/Camera2D/ColorRect/HeightPreview")
		h_preview_sprite.texture = h_img


func tempmap_preview():
	var t_img = Image.new()
	t_img.create(img_width, img_height, false, Image.FORMAT_RGBA8)
	t_img.lock()
