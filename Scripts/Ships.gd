extends Node2D
var available_names = []
var taken_names = []
var player

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

func get_officer_slots(hull_class):
	var cog_slots = {
		"Quartermaster": true,
		"1st Lieutenant": false,
		"2nd Lieutenant": false,
		"3rd Lieutenant": false,
		"Bosun": false,
		"Surgeon": false,
		"Navigator": false,
		"Master Gunner": false,
		"Carpenter": false,
		"Engineer": false}
	var galleon_slots = {
		"Quartermaster": true,
		"1st Lieutenant": false,
		"2nd Lieutenant": false,
		"3rd Lieutenant": false,
		"Bosun": false,
		"Surgeon": false,
		"Navigator": false,
		"Master Gunner": false,
		"Carpenter": false,
		"Engineer": false}
	var slots_by_class = {
		"cog": cog_slots,
		"galleon": galleon_slots}
	return slots_by_class[hull_class]
	
