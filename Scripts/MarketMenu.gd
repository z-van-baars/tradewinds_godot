extends TextureRect

var artikels
var sounds
var open_city
var player
var city_menu

var artikel_label_scene = preload("res://Scenes/UI/ArtikelLabel.tscn")
var quantity_label_scene = preload("res://Scenes/UI/QuantityLabel.tscn")
var value_label_scene = preload("res://Scenes/UI/QuantityLabel.tscn")
var transaction_total = 0
var artikels_to_buy = {}
var artikels_to_sell = {}
var artikel_to_sell = 0
var artikel_to_buy = 0
var city_artikels_list = []
var player_artikels_list = []
var market_artikels_column
var market_quantities_column
var market_values_column
var player_artikels_column
var player_quantities_column
var player_values_column
var dragging = false
var drag_offset = Vector2(0, 0)


func _ready():
	artikels = get_tree().root.get_node("Main/Artikels")
	sounds = get_tree().root.get_node("Main/Sounds")
	market_artikels_column = $MarketArtikels/ArtikelsVbox
	market_quantities_column = $MarketArtikels/QuantitiesVbox
	market_values_column = $MarketArtikels/ValueVbox
	player_artikels_column = $PlayerArtikels/ArtikelsVbox
	player_quantities_column = $PlayerArtikels/QuantitiesVbox
	player_values_column = $PlayerArtikels/ValueVbox
	player = get_tree().root.get_node("Main/Player")
	var x = get_viewport().size.x / 2 - rect_size.x / 2
	var y = get_viewport().size.y / 2 - rect_size.y / 2
	rect_position = Vector2(x, y)
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
	$CityName.text = "City Market"
	city_artikels_list = []
	player_artikels_list = []
	for t_column in [
		market_artikels_column,
		market_quantities_column,
		market_values_column]:
		for child in t_column.get_children():
			child.queue_free()
	for t_column in [
		player_artikels_column,
		player_quantities_column,
		player_values_column]:
		for child in t_column.get_children():
			child.queue_free()

func set_all():
	clear_all()
	city_menu = get_tree().root.get_node("Main/UILayer/CityMenu")
	$CityName.text = str(open_city.city_name) + " Market"
	$SilverLabel.text = "Silver: " + str(player.silver)
	create_market_labels()
	create_player_labels()
	# bug! this next line should turn on visibility but it doesn't!
	# not really a huge deal but I'd like to know why it doesn't work
	$MarketArtikels/ArtikelsVbox.get_children()[0].set_box_visible(true)
	$Balance.set_all(
		artikels_to_buy,
		artikels_to_sell,
		open_city,
		transaction_total)

func create_market_labels():
	var list_count = 0
	for artikel in artikels.artikel_list:
		if open_city.artikel_supply[artikel] > 0:
			city_artikels_list.append(artikel)
			var alabel = artikel_label_scene.instance()
			var qlabel = quantity_label_scene.instance()
			var vlabel = value_label_scene.instance()
			alabel.get_node("Label").text = str(artikel)
			alabel.artikel_list_index = list_count
			alabel.connect_box(self)
			qlabel.get_node("Label").text = str(open_city.artikel_supply[artikel])
			vlabel.get_node("Label").text = str(open_city.get_price(artikel))
			vlabel.get_node("Label").modulate = artikels.get_color(artikel, open_city.get_price(artikel))
			market_artikels_column.add_child(alabel)
			market_quantities_column.add_child(qlabel)
			market_values_column.add_child(vlabel)
			list_count += 1

func create_player_labels():
	var list_count = 0
	for artikel in artikels.artikel_list:
		if player.get_cargo_quantity(artikel) > 0:
			player_artikels_list.append(artikel)
			var alabel = artikel_label_scene.instance()
			var qlabel = quantity_label_scene.instance()
			var vlabel = value_label_scene.instance()
			alabel.get_node("Label").text = str(artikel)
			alabel.artikel_list_index = list_count
			alabel.sell = true
			alabel.connect_box(self)
			qlabel.get_node("Label").text = str(player.get_cargo_quantity(artikel))
			vlabel.get_node("Label").text = str(open_city.get_price(artikel))
			vlabel.get_node("Label").modulate = artikels.get_color(artikel, open_city.get_price(artikel))
			player_artikels_column.add_child(alabel)
			player_quantities_column.add_child(qlabel)
			player_values_column.add_child(vlabel)
			list_count += 1

func _on_XButton_pressed():
	get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel").hide()
	get_tree().paused = false
	reset_transaction()
	clear_all()
	hide()
	sounds.get_node("UI/Click_1").play()

func _on_MarketButton_pressed():
	city_menu.hide()
	show()

func _on_Artikel_mouse_hovered():
	sounds.get_node("UI/Click_2").play()

func _on_Artikel_clicked(artikel_list_id, sell):
	sounds.get_node("UI/Click_1").play()
	if sell:
		$PlayerArtikels/ArtikelsVbox.get_children()[artikel_to_sell].set_box_visible(false)
		artikel_to_sell = artikel_list_id
		$PlayerArtikels/ArtikelsVbox.get_children()[artikel_to_sell].set_box_visible(true)
	elif not sell:
		$MarketArtikels/ArtikelsVbox.get_children()[artikel_to_buy].set_box_visible(false)
		artikel_to_buy = artikel_list_id
		$MarketArtikels/ArtikelsVbox.get_children()[artikel_to_buy].set_box_visible(true)

func _on_BackButton_pressed():
	reset_transaction()
	hide()
	city_menu.show()
	sounds.get_node("UI/Click_1").play()

func _on_MarketUp_pressed():
	pass # Replace with function body.

func _on_MarketDown_pressed():
	pass # Replace with function body.

func _on_PlayerUp_pressed():
	pass # Replace with function body.

func _on_PlayerDown_pressed():
	pass # Replace with function body.

func _on_MarketMenu_visibility_changed():
	clear_transaction()
	clear_all()
	set_all()

func _on_DragButton_button_down():
	dragging = true
	drag_offset = get_global_mouse_position() - rect_position

func _on_DragButton_button_up():
	dragging = false
	drag_offset = rect_position - get_global_mouse_position()

func _on_SellButton_pressed():
	var artikel_str = player_artikels_list[artikel_to_sell]
	get_tree().root.get_node("Main/UILayer/QuantityPopup").set_all(
		artikel_str,
		player.get_cargo_quantity(artikel_str),
		open_city.get_price(artikel_str),
		player.silver)
	get_tree().root.get_node("Main/UILayer/QuantityPopup").show()
	sounds.get_node("UI/Click_1").play()


func _on_BuyButton_pressed():
	var artikel_str = city_artikels_list[artikel_to_buy]
	get_tree().root.get_node("Main/UILayer/QuantityPopup").set_all(
		artikel_str,
		open_city.artikel_supply[artikel_str],
		-open_city.get_price(artikel_str),
		player.silver)
	get_tree().root.get_node("Main/UILayer/QuantityPopup").show()
	sounds.get_node("UI/Click_1").play()


func _on_QuantityPopup_purchase(artikel_str, quantity):
	artikels_to_buy[artikel_str] += quantity
	player.increment_cargo(artikel_str, quantity)
	open_city.increment_supply(artikel_str, -quantity)
	transaction_total -= quantity * open_city.get_price(artikel_str)
	set_all()


func _on_QuantityPopup_sale(artikel_str, quantity):
	artikels_to_sell[artikel_str] += quantity
	player.increment_cargo(artikel_str, -quantity)
	open_city.increment_supply(artikel_str, quantity)
	transaction_total += quantity * open_city.get_price(artikel_str)
	set_all()

func clear_transaction():
	transaction_total = 0
	artikels_to_buy = {}
	artikels_to_sell = {}
	for each in artikels.artikel_list:
		artikels_to_buy[each] = 0
		artikels_to_sell[each] = 0

func reset_transaction():
	for each in Array(artikels_to_buy.keys()):
		var artikel_str = each
		var quantity = artikels_to_buy[each]
		player.increment_cargo(artikel_str, -quantity)
		open_city.increment_supply(artikel_str, quantity)
	for each in Array(artikels_to_sell.keys()):
		var artikel_str = each
		var quantity = artikels_to_sell[each]
		player.increment_cargo(artikel_str, quantity)
		open_city.increment_supply(artikel_str, -quantity)
	clear_transaction()

func _on_DoneButton_pressed():
	if -transaction_total > player.silver:
		print("not enough money!")
		print(str(-transaction_total), " ", player.silver)
		return
	for each in Array(artikels_to_buy.keys()):
		var artikel_str = each
		var quantity = artikels_to_buy[each]
	for each in Array(artikels_to_sell.keys()):
		var artikel_str = each
		var quantity = artikels_to_sell[each]
	player.increment_silver(transaction_total)
	sounds.get_node("UI/Coins_1").play()
	clear_transaction()
	hide()
	city_menu.show()
	

func _on_Reset_pressed():
	sounds.get_node("UI/Click_1").play()
	reset_transaction()
	set_all()
