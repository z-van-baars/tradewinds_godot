extends Node

func _ready():
	$UILayer/MainMenu.show()
	get_tree().paused = true

func load_game():
	pass

func new_game():
	$WorldGen.gen_new()
	$Player/Ship.randomize_start($Cities)


func _on_NewGameButton_pressed():
	get_tree().paused = false
	$UILayer/LoadSplash.show()
	new_game()
	$UILayer/LoadSplash.hide()
