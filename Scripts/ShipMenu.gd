extends TextureRect

var sounds
var artikels
var player
var ship
var artikel_label_scene = preload("res://Scenes/UI/ArtikelLabel.tscn")
var quantity_label_scene = preload("res://Scenes/UI/QuantityLabel.tscn")
var officer_portrait_scene = preload("res://Scenes/UI/OfficerPortrait.tscn")
var dragging = false
var drag_offset = Vector2(0, 0)
var player_artikels_list = []
var player_artikels_column
var player_quantities_column
var tabs

func _ready():
	sounds = get_tree().root.get_node("Main/Sounds")
	artikels = get_tree().root.get_node("Main/Artikels")
	player_artikels_column = $CargoTab/PlayerArtikels/ArtikelsVbox
	player_quantities_column = $CargoTab/PlayerArtikels/QuantitiesVbox
	player = get_tree().root.get_node("Main/Player")
	ship = get_tree().root.get_node("Main/Player/Ship")
	tabs = [
		$ShipTab,
		$CargoTab,
		$OfficersTab,
		$CrewTab,
		$MoraleTab,
		$EquipmentTab]

func _process(delta):
	# Right now it's possible to drag the menu offscreen
	# so that it cannot be closed or exited
	# need to either:
	# 1 - bound dragging to screen size - menu size
	# 2 - remove menus that are offscreen
	# 3 - add manual way to close offscreen menus - keyboard shortcut esc
	if dragging:
		rect_position = get_global_mouse_position() - drag_offset

func reset_ship_tab():
	$ShipTab/ShipName.text = ship.ship_name
	$ShipTab/HullLabel.text = ship.hull.capitalize()
	$ShipTab/SpeedLabel.text = str(ship.speed)
	$ShipTab/CargoLabel.text = str(ship.get_burthen()) + " / " + str(ship.cargo_cap)

func reset_cargo_tab():
	create_cargo_labels()
	
func set_all():
	get_tree().paused = true
	clear_all()
	reset_ship_tab()
	reset_cargo_tab()
	
	# $ShipSprite.texture = load("res://Ships/" + ship.hull + "/down_right_1.png")
	$ShipTab.show()

func clear_all():
	var x = get_viewport().size.x / 2 - rect_size.x / 2
	var y = get_viewport().size.y / 2 - rect_size.y / 2
	rect_position = Vector2(x, y)
	player_artikels_list = []
	for t_column in [
		player_artikels_column,
		player_quantities_column]:
		for child in t_column.get_children():
			child.queue_free()

func create_cargo_labels():
	var list_count = 0
	for artikel in artikels.artikel_list:
		if player.get_cargo_quantity(artikel) > 0:
			player_artikels_list.append(artikel)
			var alabel = artikel_label_scene.instance()
			var qlabel = quantity_label_scene.instance()
			alabel.get_node("Label").text = str(artikel)
			alabel.artikel_list_index = list_count
			alabel.sell = true
			alabel.connect_box(self)
			qlabel.get_node("Label").text = str(player.get_cargo_quantity(artikel))
			player_artikels_column.add_child(alabel)
			player_quantities_column.add_child(qlabel)
			list_count += 1

func create_officer_portraits():
	for officer_title in ship.officers.keys():
		var new_officer_portrait = officer_portrait_scene.instance()
		$OfficersTab/OfficerPortraits.add_child(new_officer_portrait)
		new_officer_portrait.load_officer(ship.officers[officer_title])
		

func close():
	get_tree().paused = false
	hide()

func _input(event):
	# in the future I might want to make esc do something other
	# than to just close the menu, for example if something is
	# selected
	if (event.is_action_pressed("logistics_key") 
		or event.is_action_pressed("ui_cancel")):
		close()

func _on_LogisticsButton_pressed():
	set_all()
	show()
	sounds.get_node("UI/Click_2").play()

func _on_DragButton_button_down():
	dragging = true
	drag_offset = get_global_mouse_position() - rect_position

func _on_DragButton_button_up():
	dragging = false
	drag_offset = Vector2(0, 0)

func _on_Player_toggle_logistics_menu():
	set_all()
	show()

func hide_all():
	for each in tabs:
		each.hide()


func _on_XButton_pressed():
	hide_all()
	close()
	sounds.get_node("UI/Click_2").play()


func _on_ShipButton_pressed():
	hide_all()
	$ShipTab.show()
	sounds.get_node("UI/Click_1").play()


func _on_CargoButton_pressed():
	hide_all()
	$CargoTab.show()
	sounds.get_node("UI/Click_1").play()

func _on_OfficersButton_pressed():
	hide_all()
	$OfficersTab.show()
	
	sounds.get_node("UI/Click_1").play()

func _on_CrewButton_pressed():
	hide_all()
	$CrewTab.show()
	
	sounds.get_node("UI/Click_1").play()


func _on_MoraleButton_pressed():
	hide_all()
	$MoraleTab.show()
	sounds.get_node("UI/Click_1").play()


func _on_EquipmentButton_pressed():
	hide_all()
	$EquipmentTab.show()
	sounds.get_node("UI/Click_1").play()
