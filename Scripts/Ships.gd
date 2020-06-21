extends Node2D
var available_names = []
var taken_names = []

func _ready():
	load_ship_names("res://Ships/ship_names.txt")

func load_ship_names(filename):
	var cn = File.new()
	cn.open(filename, File.READ)
	while not cn.eof_reached():
		var line = cn.get_line()
		available_names.append(line)
	cn.close()

func get_name():
	var r_name = available_names[randi() % available_names.size()]
	taken_names.append(r_name)
	available_names.erase(r_name)
	return r_name
