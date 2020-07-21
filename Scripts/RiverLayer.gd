extends Node2D
var biome_map
var rivers = []

func _ready():
	biome_map = get_tree().root.get_node("Main/WorldGen/BiomeMap")

func _process(delta):
	position = biome_map.position
	update()

func _draw():
	for river in rivers:
		draw_river(river)
	
func draw_river(river_pts):
	draw_polyline(river_pts, Color.blue, 15)
