extends TextureRect
var a_box_scene
var tools
var artikels
var sounds
var player
var entity
var market_exchange
var open_city
var city_menu
var shift = false
var ctrl = false
var dragging = false
var in_give_zone
var in_take_zone
var to_take = {}
var to_give = {}
var transaction_total = 0
var total_profit = {}
var total_cost = {}

func _ready():
	sounds = get_tree().root.get_node("Main/Sounds")
	artikels = get_tree().root.get_node("Main/Artikels")
	player = get_tree().root.get_node("Main/Player")
	city_menu = get_tree().root.get_node("Main/UI/CityMenu")
	a_box_scene = preload("res://Scenes/UI/ArtikelBox.tscn")
	clear_all()

func _input(event):
	if dragging == true:
		if event is InputEventMouseMotion:
			$DragBox.rect_position = get_viewport().get_mouse_position() - rect_position - Vector2(2, 2)
		if event.is_action_released("left_click"):
			dragging = false
			$DragBox.hide()
			$DropTimer.start()
	else:
		if event is InputEventMouseMotion and $HoverTimer.is_stopped() == false:
			$HoverBox.rect_position = get_viewport().get_mouse_position() - rect_position
			$HoverTimer.stop()
			$HoverTimer.start()
			$HoverBox.hide()
	if event.is_action_pressed("left_shift"):
		shift = true
	elif event.is_action_pressed("left_control"):
		ctrl = true
	elif event.is_action_released("left_shift"):
		shift = false
	elif event.is_action_released("left_control"):
		ctrl = false
		
func transfer_goods(artikel_str, q, taking):
	if taking == false:
		if to_take[artikel_str] > 0:
			if to_take[artikel_str] > q:
				to_take[artikel_str] -= q
			else:
				to_give[artikel_str] = q - to_take[artikel_str]
				to_take[artikel_str] = 0
		elif to_take[artikel_str] == 0:
			to_give[artikel_str] += q
		player.increment_cargo(artikel_str, -q)
		open_city.increment_cargo(artikel_str, q)
	elif taking == true:
		if to_give[artikel_str] > 0:
			if to_give[artikel_str] > q:
				to_give[artikel_str] -= q
			else:
				to_take[artikel_str] = q - to_give[artikel_str]
				to_give[artikel_str] = 0
		elif to_give[artikel_str] == 0:
			to_take[artikel_str] += q
		player.increment_cargo(artikel_str, q)
		open_city.increment_cargo(artikel_str, -q)

	total_profit[artikel_str] = to_give[artikel_str] * open_city.get_price(artikel_str)
	total_cost[artikel_str] = to_take[artikel_str] * open_city.get_price(artikel_str)

	set_all()
func drop_goods():
	print("Dropped " + $DragBox.artikel_str + " * " + str($DragBox.quantity) + "!")
	if in_give_zone:
		print("into give zone!")
		if $DragBox.taking == false:
			transfer_goods(
				$DragBox.artikel_str,
				$DragBox.quantity,
				$DragBox.taking)
	if in_take_zone:
		print("into take zone!")
		if $DragBox.taking == true:
			transfer_goods(
				$DragBox.artikel_str,
				$DragBox.quantity,
				$DragBox.taking)

func load_exchange(load_entity, load_city_menu=null):
	entity = load_entity
	if load_city_menu != null:
		city_menu = load_city_menu
		market_exchange = true
		open_city = load_city_menu.open_city
	clear_exchange()

func revert_exchange():
	for each in to_give:
		if to_give[each] > 0:
			player.increment_cargo(each, to_give[each])
			open_city.increment_cargo(each, -to_give[each])
	for each in to_take:
		if to_take[each] > 0:
			open_city.increment_cargo(each, to_take[each])
			player.increment_cargo(each, -to_take[each])
	clear_exchange()

func clear_exchange():
	for each in artikels.artikel_list:
		to_take[each] = 0
		to_give[each] = 0
		total_cost[each] = 0
		total_profit[each] = 0

func clear_all():
	for child in $EntityGrid.get_children():
		child.queue_free()
	for child in $ShipGrid.get_children():
		child.queue_free()
	
	for child in $ExchangeGrid.get_children():
		child.queue_free()

	$BalanceBox/AmountLabel.text = "0"
	$BalanceBox.hide()

func set_all():
	# Firing this clear statement here works to reset the menu anew, but for 
	# some reason set_all() is being called elsewhere 3x before showing 
	#the exchange screen and I don't know why
	clear_all()
	var transaction_balance = 0
	if market_exchange == true:
		$CityName.text = open_city.city_name + " Market"
		$BalanceBox/AmountLabel.text = str(transaction_balance)
		$BalanceBox.show()
	var player_artikels_list = []
	var entity_artikels_list = []
	var to_take_list = []
	var to_give_list = []
	
	for artikel in artikels.artikel_list:
		if player.get_cargo_quantity(artikel) > 0:
			player_artikels_list.append(artikel)
		if entity.get_cargo_quantity(artikel) > 0:
			entity_artikels_list.append(artikel)
		if to_give[artikel] > 0:
			to_give_list.append(artikel)
		if to_take[artikel] > 0:
			to_take_list.append(artikel)
	for each in entity_artikels_list:
		var new_box = a_box_scene.instance()
		$EntityGrid.add_child(new_box)
		new_box.load_artikel(
			each,
			entity.get_cargo_quantity(each),
			open_city.get_price(each),
			true)
		new_box.connect_signals(self)

	for each in player_artikels_list:
		var new_box = a_box_scene.instance()
		$ShipGrid.add_child(new_box)
		new_box.load_artikel(
			each,
			player.get_cargo_quantity(each),
			open_city.get_price(each))
		new_box.connect_signals(self)
	transaction_total = 0
	for each in to_take_list:
		var new_box = a_box_scene.instance()
		$ExchangeGrid.add_child(new_box)
		new_box.load_artikel(
			each,
			to_take[each],
			total_cost[each])
		new_box.set_price_color(Color.red)
		new_box.connect_signals(self)
		transaction_total += total_cost[each]
	for each in to_give_list:
		var new_box = a_box_scene.instance()
		$ExchangeGrid.add_child(new_box)
		new_box.load_artikel(
			each,
			to_give[each],
			total_profit[each])
		new_box.in_exchange = true
		new_box.set_price_color(Color.green)
		new_box.connect_signals(self)
		transaction_total -= total_profit[each]
	$BalanceBox/AmountLabel.text = str(-transaction_total)
	if transaction_total > 0:
		$BalanceBox/AmountLabel.modulate = Color.red
	elif transaction_total < 0:
		$BalanceBox/AmountLabel.modulate = Color.green
	else:
		$BalanceBox/AmountLabel.modulate = Color.gold
	
	$SilverRemainingLabel.text = str(player.silver - transaction_total)
	if player.silver - transaction_total < 0:
		$SilverRemainingLabel.modulate = Color.red
	else:
		$SilverRemainingLabel.modulate = Color.gold

func _on_ArtikelBox_hovered(artikel_box_node):
	if dragging == false:
		$HoverBox/NameLabel.text = artikel_box_node.artikel_str
		$HoverTimer.start()

func _on_ArtikelBox_clicked(artikel_box_node):
	var q = 1
	if shift == true:
		q = 5
	if ctrl == true:
		q = artikel_box_node.quantity
		transfer_goods(artikel_box_node.artikel_str, q, artikel_box_node.taking)
		return
	q = min(q, artikel_box_node.quantity)
	dragging = true
	$HoverTimer.stop()
	$HoverBox.hide()
	$DragBox.load_artikel(artikel_box_node.artikel_str, q, artikel_box_node.taking)
	$DragBox.rect_position = get_viewport().get_mouse_position() - rect_position - Vector2(2, 2)
	$DragBox.show()
	$DragBox/Backing.show()


func _on_HoverTimer_timeout():
	$HoverBox.show()

func _on_MarketButton_pressed():
	show()

func _on_XButton_pressed():
	clear_all()
	get_tree().paused = false
	hide()

func _on_BackButton_pressed():
	clear_all()
	hide()
	if market_exchange == true:
		city_menu.show()

func _on_GiveZone_mouse_entered():
	in_give_zone = true

func _on_GiveZone_mouse_exited():
	in_give_zone = false

func _on_TakeZone_mouse_entered():
	in_take_zone = true

func _on_TakeZone_mouse_exited():
	in_take_zone = false


func _on_DropTimer_timeout():
	drop_goods()


func _on_ResetButton_pressed():
	sounds.get_node("UI/Click_1").play()
	revert_exchange()
	set_all()

func _on_DoneButton_pressed():
	if transaction_total > player.silver:
		sounds.get_node("UI/Negative_1").play()
		return
	if to_give.size() == 0 and to_take.size() == 0:
		sounds.get_node("UI/Click_1").play()
		hide()
	player.silver -= transaction_total
	sounds.get_node("UI/Coins_1").play()
	clear_exchange()
	set_all()
	
