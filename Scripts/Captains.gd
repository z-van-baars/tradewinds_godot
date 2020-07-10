extends Node2D
var captain_scene = preload("res://Scenes/Captain.tscn")
var ship_scene = preload("res://Ships/Ship.tscn")
var player
var portraits = []
var available_portrait_ids = []

func _ready():
	player = get_tree().root.get_node("Main/Player")
	portraits = load_portraits('res://Assets/Characters/Portraits/')
	for p in range(portraits.size()):
		available_portrait_ids.append(p)

func load_portraits(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with(".import"):
			files.append(file)

	dir.list_dir_end()
	var image_files = []
	for each in files:
		image_files.append(
			load("res://Assets/Characters/Portraits/" + each))
		print(each)
	return image_files
		

func spawn_captain(world_pos):
	var new_captain = captain_scene.instance()
	new_captain.portrait_id = available_portrait_ids[randi() % available_portrait_ids.size()]
	available_portrait_ids.erase(new_captain.portrait_id)
	add_child(new_captain)
	var new_ship = ship_scene.instance()
	new_captain.add_child(new_ship)
	new_ship.position = world_pos
	new_ship.initialize_stats("galleon", new_captain)
	new_ship.connect_signals(
		player,
		get_tree().root.get_node("Main/UILayer/InfoCard"),
		get_tree().root.get_node("Main/Dispatcher"))

func choose_random_greeting():
	var greetings_positive = [
		"Hello, what can I do for you?",
		"To what do I owe this pleasure?",
		"What brings you to these parts?",
		"Ah, it has been too long!",
		"Good day!"]
	var greetings_nuetral = [
		"What can I do for you?",
		"What brings you to these parts?",
		"Is there something I can do for you?",
		"Hello."]
	var greetings_negative = [
		"Let's make this short.",
		"What is it that you need from me?",
		"Isn't there someone else you should be bothering?",
		"Let's get this over with.",
		"Do you really need to be bothering me right now?"
	]
