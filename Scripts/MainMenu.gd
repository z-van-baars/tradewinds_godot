extends TextureRect

var sounds

func _ready():
	sounds = get_tree().root.get_node("Main/Sounds")

func _on_NewGameButton_pressed():
	sounds.get_node("UI/Click_1").play()
	hide()
	
