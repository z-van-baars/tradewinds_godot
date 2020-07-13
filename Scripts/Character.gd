extends Node2D

var player
var characters
var disposition
var stats = {}
var portrait_id
var name_str
var title= " ~ "

func _ready():
	player = get_tree().root.get_node("Main/Player")
	characters = get_tree().root.get_node("Main/Characters")

func initialize():
	portrait_id = (
		characters.available_portrait_ids[randi() % characters.available_portrait_ids.size()])
	characters.available_portrait_ids.erase(portrait_id)
	name_str = characters.first_names[randi() % characters.first_names.size()]
	name_str = name_str + characters.surnames[randi() % characters.surnames.size()]
	randomize_stats()

func randomize_stats():
	stats["Honesty"] = randi()%20+1
	stats["Trust"] = randi()%20+1
	stats["Intelligence"] = randi()%20+1
	stats["Perception"] = randi()%20+1
	stats["Charisma"] = randi()%20+1
	stats["Aggresiveness"] = randi()%20+1
	stats["Leadership"] = randi()%20+1

func choose_greeting():
	return characters.choose_random_greeting()

func get_insult_response():
	return characters.get_insult_response()

func get_compliment_response():
	return characters.get_compliment_response()
