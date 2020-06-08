extends Node2D

var camera
var tools

func _ready():
	tools = get_tree().root.get_node("Main/Tools")
	camera = $Ship/Camera2D


func _input(event):
	if event is InputEventScreenTouch and event.pressed:

		$Ship.target = get_viewport().get_canvas_transform().xform_inv(event.position)
		$Ship.target = $Ship.target * camera.zoom * camera.zoom
		$Ship.direction = ($Ship.target - $Ship.position).normalized()
		print("Event position: " + str(event.position))
		print("Ship Target: " + str($Ship.target))
		print("Ship position: " + str($Ship.position))
		print("Player position: " + str(position))
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
