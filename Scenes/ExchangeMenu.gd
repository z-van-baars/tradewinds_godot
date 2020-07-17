extends TextureRect
var a_box_scene
var tools
var sounds
var player
var entity
var market_exchange
var open_city
var city_menu

func _ready():
	sounds = get_tree().root.get_node("Main/Sounds")
	city_menu = get_tree().root.get_node("Main/UI/CityMenu")
	a_box_scene = preload("res://Scenes/UI/ArtikelBox.tscn")
	clear_all()
	randomize_artikels()

func _input(event):
	print(event)
	print(event is InputEventMouseMotion)
	if event is InputEventMouseMotion and $HoverTimer.is_stopped() == false:
		$HoverBox.rect_position = get_viewport().get_mouse_position() - rect_position
		$HoverTimer.start()
		$HoverBox.hide()

func load_exchange(player, entity, city_menu=null):
	player = player
	entity = entity
	if city_menu != null:
		market_exchange = true
		open_city = city_menu.open_city

func clear_all():
	for child in $EntityGrid.get_children():
		child.queue_free()
	for child in $ShipGrid.get_children():
		child.queue_free()


func randomize_artikels():
	var listo = [
		["Cheese", 10, 10],
		["Bread", 15, 5],
		["Rum", 5, 100]
	]
	for each in listo:
		var new_box = a_box_scene.instance()
		$EntityGrid.add_child(new_box)
		new_box.load_artikel(each[0], each[1], each[2])
		new_box.connect_signals(self)

	for each in listo:
		var new_box = a_box_scene.instance()
		$ShipGrid.add_child(new_box)
		new_box.load_artikel(each[0], each[1] * 2, each[2] - 3)
		new_box.connect_signals(self)

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ArtikelBox_hovered(artikel_box_node):
	print("Exchange Menu Hovered!")
	$HoverBox/NameLabel.text = artikel_box_node.artikel_str
	$HoverTimer.start()


func _on_HoverTimer_timeout():
	$HoverBox.show()
