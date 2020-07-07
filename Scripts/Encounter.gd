extends ColorRect

var entity = null
var captain = null

func set_all(target_entity):
	entity = target_entity
	captain = target_entity.captain
	$EntityLabel.text = target_entity.ship_name
	$CaptainLabel.text = "Captained by " + target_entity.captain.name_str
	$MessageLabel.text = select_greeting(captain)


func select_greeting(captain):
	return "Greetings, how can I help you?"
	
func clear_all():
	entity = null
	captain = null
	$EntityLabel.text = " "
	$CaptainLabel.text = " "

func _on_LeaveButton_pressed():
	visible = false

func _on_Dispatcher_open_encounter_screen(entity, target_entity):
	set_all(target_entity)
	get_tree().paused = true
	visible = true
