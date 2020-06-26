extends ColorRect

var status_label = get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel")


func _on_WinButton_pressed():
	$OutcomeMessageTimer.start()
	status_label.text = "you won"
	visible = false


func _on_LoseButton_pressed():
	$OutcomeMessageTimer.start()
	status_label.text = "you lost"
	visible = false


func _on_FightButton_pressed():
	visible = true
