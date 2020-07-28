extends Node2D
var tools

func _ready():
	tools = get_tree().root.get_node("Main/Tools")


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

var biome_production = {
	"alpine": {"Timber": 2, "Pelts": 1},
	"conifer": {"Timber": 3, "Pelts": 2},
	"desert": {"Gold": 1, "Gems": 1, "Silver": 2, "Incense": 3, "Saffron": 1, "Opium": 2, "Saltpeter": 2, "Silk": 2},
	"forest": {"Timber": 3, "Pelts": 1},
	"grassland": {"Wool": 2, "Beef": 3, "Leather": 1, "Cheese": 2, "Butter": 1, "Vegetables": 3, "Flax": 2},
	"jungle": {"Allspice": 1, "Cardomom": 1, "Cinnamon": 1, "Cloves": 1,
			   "Cocoa": 1, "Coffee": 1, "Cumin": 1, "Ginger": 1, "Mustard": 1, "Nutmeg": 1,
			   "Pepper": 1, "Turmeric": 1, "Vanilla": 1, "Tea": 4, "Tropical Fruit": 10, "Sugar": 5},
	"lake": {"Fish": 1},
	"ocean": {"Fish": 10, "Shellfish": 8, "Ivory": 1},
	"plains": {"Grain": 10, "Opium": 1, "Wine": 3, "Fruit": 6, "Vegetables": 6, "Hemp": 5, "Flax": 5, "Olive Oil": 4, "Citrus": 2, "Cotton": 3},
	"savannah": {"Grain": 10, "Opium": 1, "Fruit": 8, "Vegetables": 6, "Olive Oil": 3, "Citrus": 2, "Cotton": 2, "Silk": 1, "Porcelain": 2},
	"sea": {"Fish": 5, "Shellfish": 4},
	"shallows": {"Fish": 10, "Shellfish": 8, "Pearls": 1, "Salt": 3},
	"snowpack": {"Ivory": 1, "Pelts": 3},
	"snowy tundra": {"Ivory": 1},
	"taiga": {"Timber": 10, "Pelts": 4, "Silver": 1},
	"tundra": {"Ivory": 1, "Pelts": 2}}
	

func random_artikel(biome_str):
	var potential_artikels = []
	for artikel_str in biome_production[biome_str].keys():
		for n in range(biome_production[biome_str][artikel_str]):
			potential_artikels.append(artikel_str)
	return tools.r_choice(potential_artikels)
