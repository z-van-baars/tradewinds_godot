extends TextureRect

func _ready():
	rect_position.y = (1080 - OS.get_screen_size().y)

func _on_NewGameButton_pressed():
	hide()
