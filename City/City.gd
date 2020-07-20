extends Node2D

signal hovered
signal unhovered
signal left_click
signal right_click

var tools
var city_tilemap
var artikels

var tile_x = 0
var tile_y = 0

var city_name = "~"
var portrait_id = randi()%3+0
var population = (randi()%100+1) * 1000
var artikel_supply = {}
var artikel_price = {}

func initialize():
	city_name = get_tree().root.get_node("Main/Cities").get_name()
	tools = get_tree().root.get_node("Main/Tools")
	artikels = get_tree().root.get_node("Main/Artikels")
	set_bounding_box()
	set_random_cargo()
	set_random_prices()
	set_label()

func set_label():
	$BBox/Label/NameLabel.text = city_name.capitalize()

func increment_cargo(artikel_name, quantity):
	artikel_supply[artikel_name] += quantity

func get_cargo_quantity(artikel_name):
	return artikel_supply[artikel_name]

func set_random_cargo():
	for _artikel in artikels.artikel_list:
		artikel_supply[_artikel] = 0
	for i in range(25):
		var r_artikel = tools.r_choice(artikels.artikel_list)
		artikel_supply[r_artikel] += randi()%10+1

func set_random_prices():
	for _artikel in artikels.artikel_list:
		var random_modifier = float(100 - ((randi()%80+1) - 40)) / 100.00
		artikel_price[_artikel] = int(artikels.base_price[_artikel] * random_modifier)

func get_price(qartikel):
	return artikel_price[qartikel]

func get_center():
	return Vector2($BBox.position.x, $BBox.position.y + 32)

func set_bounding_box():
	city_tilemap = get_tree().root.get_node("Main/WorldGen/CityMap")
	$BBox.position = city_tilemap.map_to_world(Vector2(tile_x, tile_y))
	$SelectionBox.position = $BBox.position



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
