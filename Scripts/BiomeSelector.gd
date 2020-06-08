extends Node2D

enum biomes {
	ALPINE,
	CONIFER,
	DESERT,
	FOREST,
	GRASSLAND,
	JUNGLE,
	LAKE,
	OCEAN,
	PLAINS,
	SAVANNAH,
	SEA,
	SHALLOWS,
	SNOWPACK,
	SNOWY_TUNDRA,
	TAIGA,
	TUNDRA}

var water_biomes = [
	"ocean",
	"lake",
	"shallows",
	"sea"
]

var biome_strings = {
	"very cold": {
		"very dry": "tundra",
		"dry": "snowy tundra",
		"wet": "snowpack",
		"very wet": "snowpack"},
	"cold": {
		"very dry": "tundra",
		"dry": "grassland",
		"wet": "taiga",
		"very wet": "alpine"},
	"cool": {
		"very dry": "plains",
		"dry": "grassland",
		"wet": "taiga",
		"very wet": "conifer"},
	"warm": {
		"very dry": "plains",
		"dry": "savannah",
		"wet": "forest",
		"very wet": "forest"},
	"hot": {
		"very dry": "desert",
		"dry": "plains",
		"wet": "savannah",
		"very wet": "jungle"}}

func get_temp_string(t):
	"""int -> string descriptor"""
	if t < 20:
		return "very cold"
	elif 20 <= t and t < 40:
		return "cold"
	elif 40 <= t and t < 60:
		return "cool"
	elif 60 <= t and t < 85:
		return "warm"
	elif 85 <= t:
		return "hot"

func get_moisture_string(m):
	"""int -> string descriptor"""
	if m < 20:
		return "very dry"
	elif 20 <= m and m < 50:
		return "dry"
	elif 50 <= m and m < 80:
		return "wet"
	elif 80 <= m:
		return "very wet"

func get_biome(t, m):
	var str_temp = get_temp_string(t)
	var str_moisture = get_moisture_string(m)
	return biome_strings[str_temp][str_moisture]
