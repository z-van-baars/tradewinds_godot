extends TextureRect

var sounds

var dragging = false
var drag_offset = Vector2(0, 0)

var quantity = 0
var max_quantity = 0
var artikel_cost = 0
var silver
var artikel_
signal purchase
signal sale

func _ready():
	sounds = get_tree().root.get_node("Main/Sounds")

func set_all(artikel_str, artikel_max, cost, psilver=-1):
	$SilverIcon.show()
	artikel_ = artikel_str
	quantity = 0
	max_quantity = artikel_max
	artikel_cost = cost
	silver = psilver
	$ArtikelLabel.text = artikel_str
	if artikel_cost < 0:
		$BuySellLabel.text = "Buy How Many?"
	else:
		$BuySellLabel.text = "Sell How Many?"
	$MaxLabel.text = str(max_quantity)
	if psilver >= 0:
		$SilverLabel.text = str(silver)
	else:
		$SilverIcon.hide()
		$SilverLabel.text = ""
	update_labels()

func update_labels():
	$QuantityLabel.text = str(quantity)
	$CostLabel.text = ""
	if artikel_cost > 0:
		$CostLabel.text += "+"
	$CostLabel.text += str(artikel_cost * quantity)

func _on_DragButton_button_down():
	pass # Replace with function body.


func _on_DragButton_button_up():
	pass # Replace with function body.



func _on_LeftArrow_pressed():
	quantity = max(0, quantity - 1)
	update_labels()
	sounds.get_node("UI/Click_1").play()


func _on_RightArrow_pressed():
	quantity = min(
			max_quantity,
			quantity + 1)
	# if we're buying, check that the player can afford this quantity,
	# if not, reduce quantity to the amount they can afford
	#  NOTE:  This cap has been removed for the new market functionality,
	# in order to allow barter with negative balances
#	if artikel_cost < 0:
#		if abs(artikel_cost) < silver:
#			quantity = min(
#				quantity,
#				int(silver / abs(artikel_cost)))
#		else:
#			quantity = 0
	update_labels()
	sounds.get_node("UI/Click_1").play()


func _on_Cancel_pressed():
	hide()
	sounds.get_node("UI/Click_1").play()


func _on_Done_pressed():
	if artikel_cost > 0:
		emit_signal("sale", artikel_, quantity)
	elif artikel_cost < 0:
		emit_signal("purchase", artikel_, quantity)
	hide()
	sounds.get_node("UI/Click_1").play()

func _on_Min_pressed():
	quantity = 0
	update_labels()
	sounds.get_node("UI/Click_1").play()
func _on_Max_pressed():
	# This stuff is now irrelevant because we don't care about costs yet
#	if artikel_cost < 0 and abs(artikel_cost) < silver:
#		quantity = min(
#			max_quantity,
#			int(silver / abs(artikel_cost)))
#	elif artikel_cost < 0 and abs(artikel_cost) > silver:
#		quantity = 0
#	else:
#		quantity = max_quantity
	quantity = max_quantity
	update_labels()
	sounds.get_node("UI/Click_1").play()
