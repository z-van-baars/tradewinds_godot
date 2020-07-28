extends Node

func _ready():
	print("starting")
	$UILayer/MainMenu.show()
	get_tree().paused = true


func load_game():
	pass

func new_game():
	$WorldGen.gen_new(300, 300)
	$UILayer/MapWidget.setup_references($WorldGen.biomemap)
	$UILayer/MapWidget.redraw_minimaps($WorldGen.biomemap)
	$Player.randomize_start($Cities)
	$Captains.generate_random_captains($Cities.get_children(), 10)
	$Calendar.set_start_date()
	$Calendar/Timer.start()


func _on_NewGameButton_pressed():
	get_tree().paused = false
	$UILayer/LoadSplash.show()
	new_game()
	$UILayer/LoadSplash.hide()
