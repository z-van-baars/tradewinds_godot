extends Node2D

var tools
var player
var portraits = []
var available_portrait_ids = []
var first_names = []
var surnames = []
var character_scene

func _ready():
	tools = get_tree().root.get_node("Main/Tools")
	player = get_tree().root.get_node("Main/Player")
	load_names()
	character_scene = preload("res://Scenes/Character.tscn")
	portraits = load_portraits('res://Assets/Characters/Portraits/')
	for p in range(portraits.size()):
		available_portrait_ids.append(p)

func load_names():
	var first_names_file = "res://Assets/Characters/names.txt"
	var surnames_file = "res://Assets/Characters/surnames.txt"
	var fn = File.new()
	fn.open(first_names_file, File.READ)
	while not fn.eof_reached():
		var line = fn.get_line()
		first_names.append(line)
	fn.close()
	var sn = File.new()
	sn.open(surnames_file, File.READ)
	while not sn.eof_reached():
		var line = sn.get_line()
		surnames.append(line)
	sn.close()

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
	return image_files

func spawn_character():
	var new_character = character_scene.instance()
	add_child(new_character)
	new_character.initialize()

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
		"Do you really need to be bothering me right now?"]
	var all_greetings = greetings_positive + greetings_nuetral + greetings_negative
	return tools.r_choice(all_greetings)

func get_insult_response():
	var insult_responses = [
		"Well I never!",
		"Get out of my face!",
		"You are the rudest person I've ever met!"]
	return tools.r_choice(insult_responses)

func get_compliment_response():
	var compliment_responses = [
		"That's very kind of you.",
		"Oh, I'm very flattered.",
		"That's a very nice thing to say."]
	return tools.r_choice(compliment_responses)
