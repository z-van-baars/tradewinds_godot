extends Node2D

signal hovered
signal unhovered
signal left_click
signal right_click

var tools
var biome_map
var city_tilemap
var artikels

var map_tile

var city_name = "~"
var portrait_id = randi()%3+0
var size = (randi()%100+1)
var population = size * 1000
var neighborhood = []
var artikel_supply = {}
var artikel_price = {}

func initialize():
	city_name = get_tree().root.get_node("Main/Cities").get_name()
	tools = get_tree().root.get_node("Main/Tools")
	biome_map = get_tree().root.get_node("Main/WorldGen/BiomeMap")
	artikels = get_tree().root.get_node("Main/Artikels")
	set_bounding_box()
	neighborhood = tools.get_nearby_tiles(map_tile, 3 + int(size / 3))
	# set_random_cargo()
	set_initial_cargo()
	set_demand_price()
	set_label()

func set_label():
	$BBox/Label/NameLabel.text = city_name.capitalize()

func increment_cargo(artikel_name, quantity):
	artikel_supply[artikel_name] += quantity

func get_cargo_quantity(artikel_name):
	return artikel_supply[artikel_name]

func init_cargo():
	for _artikel in artikels.artikel_list:
		artikel_supply[_artikel] = 0

func set_random_cargo():
	for i in range(25):
		var r_artikel = tools.r_choice(artikels.artikel_list)
		artikel_supply[r_artikel] += randi()%10+1

func set_initial_cargo():
	init_cargo()
	for i in range(100):
		production()

func production():
	for j in range(size):
		var tile_to_work = tools.r_choice(neighborhood)
		work_tile(tile_to_work)
		
func set_random_prices():
	for _artikel in artikels.artikel_list:
		var random_modifier = float(100 - ((randi()%80+1) - 40)) / 100.00
		artikel_price[_artikel] = int(artikels.base_price[_artikel] * random_modifier)

func set_demand_price():
	for _artikel in artikels.artikel_list:
		
		artikel_price[_artikel] = max(1,
			artikels.base_price[_artikel] - get_cargo_quantity(_artikel))

func get_price(qartikel):
	return artikel_price[qartikel]

func get_center():
	return Vector2($BBox.position.x, $BBox.position.y + 32)

func set_bounding_box():
	city_tilemap = get_tree().root.get_node("Main/WorldGen/CityMap")
	$BBox.position = city_tilemap.map_to_world(map_tile)
	$SelectionBox.position = $BBox.position

func work_tile(tile):
	var artikel_to_produce = artikels.get_production(biome_map.get_cellv(tile))
	increment_cargo(artikel_to_produce, 1)
func connect_signals(player_node, info_card):
	self.connect(
		"right_click",
		player_node,
		"_on_City_right_click")
	self.connect(
		"hovered",
		info_card,
		"_on_Entity_hovered")
	self.connect(
		"unhovered",
		info_card,
		"_on_Entity_unhovered"
	)

func _on_BBox_mouse_entered():
	$SelectionBox.visible = true
	$BBox/Label.visible = true
	$BBox/Label/NameLabel.visible = true
	emit_signal("hovered",
		0,
		[city_name,
		 population])

func _on_BBox_mouse_exited():
	$SelectionBox.visible = false
	$BBox/Label.visible = false
	$BBox/Label/NameLabel.visible = false
	emit_signal("unhovered")

func _on_BBox_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("right_click"):
		emit_signal("right_click", self)
