extends ColorRect

var sounds
var entity = null
var character
var captains
var characters

func _ready():
	sounds = get_tree().root.get_node("Main/Sounds")
	captains = get_tree().root.get_node("Main/Captains")
	characters = get_tree().root.get_node("Main/Characters")

func set_all(target_character, target_entity=null):
	print(target_character)
	character = target_character
	if target_entity != null:
		entity = target_entity
		$EntityLabel.text = entity.ship_name
		$CharacterLabel.text = "Captained by " + character.name_str
	else:
		$CharacterLabel.text = character.name_str
	$MessageLabel.text = character.choose_greeting()
	$Portrait.texture = characters.portraits[character.portrait_id]
	

	
func clear_all():
	entity = null
	character = null
	$EntityLabel.text = " "
	$CharacterLabel.text = " "

func _on_LeaveButton_pressed():
	visible = false
	get_tree().paused = false
	sounds.get_node("UI/Click_1").play()

func _on_Dispatcher_open_encounter_screen(target_character, target_entity):
	set_all(target_character, target_entity)
	get_tree().paused = true
	visible = true


func _on_FightButton_pressed():
	visible = false
	sounds.get_node("UI/Click_1").play()


func _on_InsultButton_pressed():
	$MessageLabel.text = character.get_insult_response()
	sounds.get_node("UI/Click_1").play()


func _on_ComplimentButton_pressed():
	$MessageLabel.text = character.get_compliment_response()
	sounds.get_node("UI/Click_1").play()
