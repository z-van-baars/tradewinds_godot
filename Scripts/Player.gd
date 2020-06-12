extends Node2D

var camera
var tools
var silver = 100
var artikels

func _ready():
	tools = get_tree().root.get_node("Main/Tools")
	artikels = get_tree().root.get_node("Main/Artikels")
	camera = $Ship/Camera2D
	for _artikel in artikels.artikel_list:
		$Ship.cargo[_artikel] = 0
	$Ship.cargo["Salted Beef"] = 3
	$Ship.cargo["Rum"] = 2
	$Ship.cargo["Bread"] = 5

func get_cargo_quantity(artikel_name):
	return $Ship.cargo[artikel_name]

func increment_cargo(artikel_name, quantity):
	$Ship.cargo[artikel_name] += quantity

func increment_silver(quantity):
	silver += quantity

func _input(event):
	if event is InputEventScreenTouch and event.pressed:

		$Ship.target = get_viewport().get_canvas_transform().xform_inv(event.position)
		$Ship.target = $Ship.target * camera.zoom * camera.zoom
		$Ship.direction = ($Ship.target - $Ship.position).normalized()
#	elif event is InputEventMouseButton:
#		if event.is_pressed():
#			# zoom in
#			if event.button_index == BUTTON_WHEEL_UP:
#				var zoom_pos = get_global_mouse_position()
#				camera.zoom.x -= 1
#				camera.zoom.y -= 1
#				camera.zoom.x = round(camera.zoom.x)
#				camera.zoom.y = round(camera.zoom.y)
#				print("\n", camera.zoom)
#			# zoom out
#			elif event.button_index == BUTTON_WHEEL_DOWN:
#				var zoom_pos = get_global_mouse_position()
#				camera.zoom.x += 1
#				camera.zoom.y += 1
#				camera.zoom.x = round(camera.zoom.x)
#				camera.zoom.y = round(camera.zoom.y)
#				print("\n", camera.zoom)
	if event.is_action_pressed("ui_zoom"):
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
