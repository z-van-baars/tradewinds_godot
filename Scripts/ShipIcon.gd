extends Sprite

func _process(delta):
	var position1 = get_tree().root.get_node("Main/Player/Ship").position
	var map_size = get_tree().root.get_node("Main/WorldGen").biomemap.size()
	var minimap_width = get_tree().root.get_node("Main/UILayer/MapWidget").rect_size.x
	var minimap_height = get_tree().root.get_node("Main/UILayer/MapWidget").rect_size.y
	var a2 = map_size * map_size
	var b2 = map_size * map_size
	var c2 = a2 + b2
	var c = sqrt(c2)
	var background_width = c * 128
	var background_height = c * 64
	# add a halfwidth because the background/world coords 
	#go negative at the midpoint
	var x2 = position1.x * (
		 minimap_width / background_width) * 1.333 + minimap_width / 2
	# 1.333 is a magic number to scale the position
	# since the minimap is a perfect square but the tilemap is not
	var y2 = position1.y * (
		minimap_height / background_height) * 1.333
	position.x = x2
	position.y = y2

