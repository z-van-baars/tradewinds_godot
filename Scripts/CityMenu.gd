extends TextureRect
var open_city
var market_menu
var portraits
var dragging = false
var drag_offset = Vector2(0, 0)

func _ready():
	clear_all()
	portraits = [
		load("res://Assets/UI/portraits/city_a.png"),
		load("res://Assets/UI/portraits/city_b.png"),
		load("res://Assets/UI/portraits/city_c.png"),
		load("res://Assets/UI/portraits/city_d.png")]

func _process(delta):
	# Right now it's possible to drag the menu offscreen
	# so that it cannot be closed or exited
	# need to either:
	# 1 - bound dragging to screen size - menu size
	# 2 - remove menus that are offscreen
	# 3 - add manual way to close offscreen menus - keyboard shortcut esc
	if dragging:
		rect_position = get_global_mouse_position() - drag_offset
func clear_all():
	var x = get_viewport().size.x / 2 - rect_size.x / 2
	var y = get_viewport().size.y / 2 - rect_size.y / 2
	rect_position = Vector2(x, y)
	$CityName.text = "N/A"
	
func set_all():
	var root = get_tree().root
	market_menu = root.get_node("Main/UILayer/MarketMenu")
	$CityName.text = str(open_city.city_name)
	$CityPortrait.texture = portraits[open_city.portrait_id]

func _on_XButton_pressed():
	get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").hide()
	get_tree().paused = false
	clear_all()
	market_menu.clear_all()
	hide()

func _on_City_clicked(city_to_open):
	get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").show()
	get_tree().paused = true
	open_city = city_to_open
	set_all()
	show()
	# get_tree().paused = true

func _on_CityMenu_visibility_changed():
	clear_all()
	set_all()

func _on_DragButton_button_down():
	dragging = true
	drag_offset = get_global_mouse_position() - rect_position

func _on_DragButton_button_up():
	dragging = false
	drag_offset = rect_position - get_global_mouse_position()
