extends ColorRect

var entity = null
var captain = null
var captains

func _ready():
	captains = get_tree().root.get_node("Main/Captains")

func set_all(target_entity):
	entity = target_entity
	captain = target_entity.captain
	$EntityLabel.text = target_entity.ship_name
	$CaptainLabel.text = "Captained by " + target_entity.captain.name_str
	$MessageLabel.text = select_greeting(captain)
	print(captain.portrait_id)
	print(captains.portraits[0])
	$Portrait.texture = captains.portraits[captain.portrait_id]


func select_greeting(captain):
	return "Greetings, how can I help you?"
	
func clear_all():
	entity = null
	captain = null
	$EntityLabel.text = " "
	$CaptainLabel.text = " "

func _on_LeaveButton_pressed():
	visible = false
	get_tree().paused = false

func _on_Dispatcher_open_encounter_screen(target_entity):
	print("pewp")
	set_all(target_entity)
	get_tree().paused = true
	visible = true


func _on_FightButton_pressed():
	visible = false
