extends ColorRect

signal battle_won
signal battle_lost
var status_label

func _ready():
	status_label = get_tree().root.get_node("Main/UILayer/DateBar/StatusLabel")


func _on_WinButton_pressed():
	$OutcomeMessageTimer.start()
	status_label.text = "you won"
	visible = false
	emit_signal("battle_won")
	get_tree().paused = false


func _on_LoseButton_pressed():
	$OutcomeMessageTimer.start()
	status_label.text = "you lost"
	visible = false
	emit_signal("battle_lost")
	get_tree().paused = false


func _on_FightButton_pressed():
	visible = true
