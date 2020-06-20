extends Label
var tools

func _ready():
	tools = get_tree().root.get_node("Main/Tools")

func _on_City_hovered(city_name, city_position):
	# visible = true
	text = city_name

func _on_City_unhovered():
	visible = false
	text = "~~"

func _process(delta):
	var pos = get_viewport().get_mouse_position()
	rect_position.x = pos.x
	rect_position.y = pos.y - 20
