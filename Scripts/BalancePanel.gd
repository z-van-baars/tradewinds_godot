extends TextureButton

var subtext_scene

func _ready():
	subtext_scene = preload("res://Scenes/UI/SmallTextLabel.tscn")

func set_all(artikels_to_buy, artikels_to_sell, open_city, transaction_total):
	$Label.text = str(transaction_total)
	if transaction_total == 0:
		$Label.modulate = Color.white
		return
	if transaction_total > 0:
		$Label.modulate = Color.green
	elif transaction_total < 0:
		$Label.modulate = Color.firebrick
	for each in $Panel/VBoxContainer.get_children():
		each.queue_free()
	var total_entries = 0
	for artikel_str in Array(artikels_to_buy.keys()):
		if artikels_to_buy[artikel_str] != 0:
			var silver_total
			silver_total = open_city.get_price(artikel_str) * artikels_to_buy[artikel_str]
			var entry_string = artikel_str + " - " + str(silver_total)
			var new_entry = subtext_scene.instance()
			new_entry.get_node("Label").text = entry_string
			new_entry.get_node("Label").modulate = Color.firebrick
			$Panel/VBoxContainer.add_child(new_entry)
			total_entries += 1
	for artikel_str in Array(artikels_to_sell.keys()):
		if artikels_to_sell[artikel_str] != 0:
			var silver_total
			silver_total = open_city.get_price(artikel_str) * artikels_to_sell[artikel_str]
			var entry_string = artikel_str + " - " + str(silver_total)
			var new_entry = subtext_scene.instance()
			new_entry.get_node("Label").text = entry_string
			new_entry.get_node("Label").modulate = Color.green
			$Panel/VBoxContainer.add_child(new_entry)
			total_entries += 1
	$Panel.rect_size.y = total_entries * 15
	$Panel/VBoxContainer.rect_size.y = total_entries * 15
	


func _on_Balance_mouse_entered():
	$Panel.show()


func _on_Balance_mouse_exited():
	$Panel.hide()
