extends Node

func _ready():
	print("starting")
	$UILayer/MainMenu.show()
	get_tree().paused = true


func load_game():
	pass

func new_game():
	$WorldGen.gen_new(100, 100)
	$UILayer/MapWidget.setup_references($WorldGen.biomemap)
	$UILayer/MapWidget.redraw_minimaps($WorldGen.biomemap)
	$Player.randomize_start($Cities)
	$Captains.generate_random_captains($Cities.get_children(), 1)
	$Calendar.set_start_date()
	$Calendar/Timer.start()


func _on_NewGameButton_pressed():
	get_tree().paused = false
	$UILayer/LoadSplash.show()
	new_game()
	$UILayer/LoadSplash.hide()
