extends Node2D

var tile_x = 0
var tile_y = 0
var tools
var city_name = "~"
var city_tilemap
var name_array = []
var artikels
var artikel_supply = {}
signal hovered
signal unhovered
signal clicked


func initialize():
	load_city_names("C:/Users/Zac/Godot Projects/Tradewinds_v1/City/city_names.txt")
	city_name = name_array[randi() % name_array.size()]
	tools = get_tree().root.get_node("Main/Tools")
	artikels = get_tree().root.get_node("Main/Artikels")
	set_bounding_box()
	set_random_supply()

func set_random_supply():
	for _artikel in artikels.artikel_list:
		artikel_supply[_artikel] = 0
	for i in range(5):
		var r_artikel = tools.r_choice(artikels.artikel_list)
		artikel_supply[r_artikel] += randi()%10+1

func set_bounding_box():
	city_tilemap = get_tree().root.get_node("Main/Cities/CityMap")
	$BBox.position = city_tilemap.map_to_world(Vector2(tile_x, tile_y))

func load_city_names(filename):
	var cn = File.new()
	cn.open(filename, File.READ)
	while not cn.eof_reached():
		var line = cn.get_line()
		name_array.append(line)
	cn.close()

func connect_signals(label_node, city_menu_node, market_menu_node):
	self.connect(
		"hovered",
		label_node,
		"_on_City_hovered")
	self.connect(
		"unhovered",
		label_node,
		"_on_City_unhovered")
	self.connect(
		"clicked",
		city_menu_node,
		"_on_City_clicked")
	self.connect(
		"clicked",
		market_menu_node,
		"_on_City_clicked")

func _on_BBox_mouse_entered():
	emit_signal("hovered", city_name)

func _on_BBox_mouse_exited():
	emit_signal("unhovered")

func _on_BBox_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			emit_signal("clicked", self)
