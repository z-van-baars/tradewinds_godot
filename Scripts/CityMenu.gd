extends TextureRect

var sounds
var open_city
var market_menu
var exchange_menu
var portraits
var dragging = false
var drag_offset = Vector2(0, 0)

func _ready():
	clear_all()
	sounds = get_tree().root.get_node("Main/Sounds")
	exchange_menu = get_tree().root.get_node("Main/UILayer/ExchangeMenu")
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
	exchange_menu.load_exchange(self.open_city, self)
	exchange_menu.set_all()
	$CityName.text = str(open_city.city_name)
	$CityPortrait.texture = portraits[open_city.portrait_id]


func _on_XButton_pressed():
	get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").hide()
	get_tree().paused = false
	clear_all()
	hide()
	sounds.get_node("UI/Click_1").play()

func _on_CityMenu_visibility_changed():
	clear_all()
	set_all()

func _on_DragButton_button_down():
	dragging = true
	drag_offset = get_global_mouse_position() - rect_position

func _on_DragButton_button_up():
	dragging = false
	drag_offset = rect_position - get_global_mouse_position()

func _on_Player_open_city_menu(city_to_open):
	get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").show()
	get_tree().paused = true
	open_city = city_to_open
	set_all()
	show()


func _on_MarketButton_pressed():
	sounds.get_node("UI/Click_1").play()
	hide()
