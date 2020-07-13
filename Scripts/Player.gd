extends Node2D

var camera
var tools

signal toggle_logistics_menu
signal open_city_menu

var spawn_mode = false

var artikels
var own_ship_selected = false
var ship_selected = null

var silver = 100

func _ready():
	tools = get_tree().root.get_node("Main/Tools")
	artikels = get_tree().root.get_node("Main/Artikels")
	camera = $Ship/Camera2D
	camera.current = true
	$Ship.initialize_stats("cog", true, self)
	$Ship.connect_signals(
		self,
		get_tree().root.get_node("Main/UILayer/InfoCard"),
		get_tree().root.get_node("Main/Dispatcher"))
	$Ship.connect(
		"destination_reached",
		self,
		"_on_Ship_destination_reached")

	for _artikel in artikels.artikel_list:
		$Ship.cargo[_artikel] = 0
	$Ship.cargo["Salted Beef"] = 3
	$Ship.cargo["Rum"] = 2
	$Ship.cargo["Bread"] = 5
	$Ship.generate_random_officers()
	

func randomize_start(cities):
	var r_city = tools.r_choice(cities.get_children())
	var neighbor_tiles = tools.get_neighbor_tiles(
		Vector2(r_city.tile_x,
				r_city.tile_y))
	# filter tiles around a random start city for water only
	var f_neighbor_tiles = tools.filter_tiles(neighbor_tiles, true)
	var r_start = tools.r_choice(neighbor_tiles)
	$Ship.position = get_tree().root.get_node("Main/WorldGen/BiomeMap").map_to_world(r_start)

func get_ship_pos():
	return $Ship.position

func get_cargo_quantity(artikel_name):
	return $Ship.cargo[artikel_name]

func increment_cargo(artikel_name, quantity):
	$Ship.cargo[artikel_name] += quantity

func increment_silver(quantity):
	silver += quantity

func _on_City_right_click(city_node):
	if own_ship_selected == true:
		$Ship.destination_city = city_node

func _on_Ship_left_click(ship_node):
	ship_selected = ship_node
	ship_node.select()
	own_ship_selected = ship_node.player_ship

func _on_Ship_right_click(ship_node):
	$Ship.target_entity = ship_node

func _on_Ship_destination_reached(destination_city):
	emit_signal("open_city_menu", destination_city)
	$Ship.clear_destination()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event.is_action_pressed("F11"):
		OS.window_fullscreen = !OS.window_fullscreen
	elif event.is_action_pressed("logistics_key"):
		emit_signal("toggle_logistics_menu")
	elif event.is_action_pressed("ui_zoom"):
		if camera.zoom.x == 1:
			camera.zoom.x = 2
			camera.zoom.y = 2
		elif camera.zoom.x == 2:
			camera.zoom.x = 4
			camera.zoom.y = 4
		elif camera.zoom.x == 4:
			camera.zoom.x = 8
			camera.zoom.y = 8
		elif camera.zoom.x == 8:
			camera.zoom.x = 1
			camera.zoom.y = 1
	elif event.is_action_pressed("spawn_key"):
		get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").visible = true
		get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").text = "Spawn Mode"
		spawn_mode = true
	elif event.is_action_released("spawn_key"):
		get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").visible = false
		get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").text = "Paused"
		spawn_mode = false
#	elif event.is_action_pressed("scrollwheel_up"):
#		var zoom_pos = get_global_mouse_position()
#		camera.zoom.x -= 1
#		camera.zoom.y -= 1
#		camera.zoom.x = round(camera.zoom.x)
#		camera.zoom.y = round(camera.zoom.y)
#	elif event.is_action_pressed("scrollwheel_down"):
#		var zoom_pos = get_global_mouse_position()
#		camera.zoom.x += 1
#		camera.zoom.y += 1
#		camera.zoom.x = round(camera.zoom.x)
#		camera.zoom.y = round(camera.zoom.y)

	if own_ship_selected == true:
		if event.is_action_pressed("right_click"):
			var new_target = get_viewport().get_canvas_transform().xform_inv(event.position)
			var adjusted_target = new_target * camera.zoom * camera.zoom
			$Ship.set_target(adjusted_target)
			
		elif event.is_action_pressed("left_click"):
			if ship_selected != null:
				ship_selected.deselect()
				ship_selected = null
				own_ship_selected = false

	elif own_ship_selected == false and ship_selected:
		if event.is_action_pressed("left_click"):
			if ship_selected != null:
				ship_selected.deselect()
				ship_selected = null
				own_ship_selected = false

	elif own_ship_selected == false and ship_selected == null:
		if event.is_action_pressed("left_click") and spawn_mode == true:
			var world_pos = get_viewport().get_canvas_transform().xform_inv(event.position)
			get_tree().root.get_node("Main/Captains").spawn_captain(world_pos)




