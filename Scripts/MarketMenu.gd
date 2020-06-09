extends TextureRect

var open_city
var city_menu
var artikel_label_scene = preload("res://Scenes/UI/ArtikelLabel.tscn")
var quantity_label_scene = preload("res://Scenes/UI/QuantityLabel.tscn")
var artikels_column
var quantities_column
var dragging = false
var drag_offset = Vector2(0, 0)

func _ready():
	artikels_column = $MarketArtikels/ArtikelsVbox
	quantities_column = $MarketArtikels/QuantitiesVbox
	clear_all()


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
	$CityName.text = "City Market"
	for t_column in [
		artikels_column,
		quantities_column]:
		for child in t_column.get_children():
			child.queue_free()


func set_all():
	city_menu = get_tree().root.get_node("Main/UILayer/CityMenu")
	$CityName.text = str(open_city.city_name) + " Market"
	create_market_labels()

func create_market_labels():
	var list_count = 0

	for artikel in open_city.artikel_supply.keys():
		var alabel = artikel_label_scene.instance()
		var qlabel = quantity_label_scene.instance()
		alabel.get_node("Label").text = str(artikel)
		qlabel.get_node("Label").text = str(open_city.artikel_supply[artikel])
#		label.rect_position.y = list_count * 22
		artikels_column.add_child(alabel)
		quantities_column.add_child(qlabel)
		list_count += 1

func create_ship_labels():
	pass

func _on_XButton_pressed():
	get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").hide()
	get_tree().paused = false
	clear_all()
	hide()

func _on_MarketButton_pressed():
	print("marketo")
	city_menu.hide()
	show()

func _on_City_clicked(city_to_open):
	open_city = city_to_open
	set_all()

func _on_BackButton_pressed():
	hide()
	city_menu.show()

func _on_MarketUp_pressed():
	pass # Replace with function body.

func _on_MarketDown_pressed():
	pass # Replace with function body.

func _on_ShipUp_pressed():
	pass # Replace with function body.

func _on_ShipDown_pressed():
	pass # Replace with function body.

func _on_MarketMenu_visibility_changed():
	clear_all()
	set_all()

func _on_DragButton_button_down():
	dragging = true
	drag_offset = get_global_mouse_position() - rect_position

func _on_DragButton_button_up():
	dragging = false
	drag_offset = rect_position - get_global_mouse_position()
