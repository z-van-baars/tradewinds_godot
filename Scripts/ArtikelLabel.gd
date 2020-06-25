extends Control


var artikel_list_index = 0
var sell = false
signal clicked

func connect_box(market_menu_node):
	self.connect(
		"clicked",
		market_menu_node,
		"_on_Artikel_clicked")

func set_box_visible(visible):
	if visible:
		$SelectionBox.show()
	else:
		$SelectionBox.hide()

func _on_Button_pressed():
	emit_signal("clicked", artikel_list_index, sell)

