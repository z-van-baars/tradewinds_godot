extends PopupMenu
var open_city
var city_menu
var artikel_label_scene = preload("res://Scenes/UI/ArtikelLabel.tscn")
var quantity_label_scene = preload("res://Scenes/UI/QuantityLabel.tscn")
func _ready():
	clear_all()

func clear_all():
	$CityName.text = "City Market"

func set_all():
	city_menu = get_tree().root.get_node("Main/UILayer/CityMenu")
	$CityName.text = str(open_city.city_name) + " Market"
	create_market_labels()

func create_market_labels():
	var list_count = 0
	var artikels_column = $MarketArtikels/ArtikelsVbox
	var quantities_column = $MarketArtikels/QuantitiesVbox
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
	get_tree().paused = false
	clear_all()
	hide()

func _on_MarketButton_pressed():
	city_menu.hide()
	popup()

func _on_City_clicked(city_to_open):
	open_city = city_to_open
	set_all()

func _on_BackButton_pressed():
	hide()
	city_menu.popup()
