extends Node

func _ready():
	new_game()

func load_game():
	pass

func new_game():
	$WorldGen.gen_new()
	$Ship.randomize_start($Cities)
