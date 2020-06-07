extends PopupMenu
var open_city
var market_menu

func _ready():
	clear_all()

func clear_all():
	$CityName.text = "N/A"
	
func set_all():
	var root = get_tree().root
	market_menu = root.get_node("Main/UILayer/MarketMenu")
	$CityName.text = str(open_city.city_name)

func _on_XButton_pressed():
	get_tree().paused = false
	clear_all()
	market_menu.clear_all()
	hide()

func _on_City_clicked(city_to_open):
	get_tree().paused = true
	open_city = city_to_open
	set_all()
	popup()
	# get_tree().paused = true


