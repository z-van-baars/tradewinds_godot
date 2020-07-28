extends Node2D

var biome_map

func _ready():
	biome_map = get_tree().root.get_node("Main/WorldGen/BiomeMap")
# PROPOSED ARTIKELS

# Game found in Alpine + Conifer Forests
var base_price = {
	"Beef": 30,
	"Beer": 50,
	"Bread": 5,
	"Butter": 35,
	"Cheese": 25,
	"Citrus": 50,
	"Coffee": 200,
	"Fish": 10,
	"Fruit": 100,
	"Grain": 5,
	"Olive Oil": 75,
	"Rum": 225,
	"Salt": 175,
	"Salted Beef": 50,
	"Shellfish": 30,
	"Sugar": 400,
	"Tea": 600,
	"Tropical Fruit": 150,
	"Vegetables": 20,
	"Wine": 125,
	"Rope": 75,
	"Ammunition": 125,
	"Bronze": 400,
	"Cannon Balls": 150,
	"Canvas": 30,
	"Clothes": 75,
	"Fine Clothes": 350,
	"Gunpowder": 200,
	"Leather": 80,
	"Linen": 125,
	"Small Arms": 250,
	"Copper": 300,
	"Cotton": 100,
	"Dyes": 150,
	"Flax": 40,
	"Hemp": 50,
	"Incense": 500,
	"Iron": 200,
	"Pelts": 300,
	"Saltpeter": 120,
	"Silk": 325,
	"Timber": 80,
	"Tin": 500,
	"Wool": 30,
	"Allspice": 450,
	"Cardomom": 375,
	"Cinnamon": 500,
	"Cloves": 550,
	"Cocoa": 425,
	"Cumin": 360,
	"Ginger": 440,
	"Mustard": 450,
	"Nutmeg": 650,
	"Opium": 410,
	"Pepper": 680,
	"Saffron": 775,
	"Tobacco": 645,
	"Turmeric": 455,
	"Vanilla": 605,
	"Gems": 715,
	"Gold": 1000,
	"Ivory": 630,
	"Pearls": 510,
	"Porcelain": 250,
	"Silver": 735,
}

var foods = [
	"Beef",
	"Beer",
	"Bread",
	"Butter",
	"Cheese",
	"Citrus",
	"Coffee",
	"Fish",
	"Fruit",
	"Grain",
	"Olive Oil",
	"Rum",
	"Salt",
	"Salted Beef",
	"Shellfish",
	"Sugar",
	"Tea",
	"Tropical Fruit",
	"Vegetables",
	"Wine"
]

var manufactured_goods = [
	"Ammunition",
	"Cannon Balls",
	"Canvas",
	"Clothes",
	"Fine Clothes",
	"Gunpowder",
	"Leather",
	"Linen",
	"Rope",
	"Small Arms"
]


var raw_materials = [
	"Copper",
	"Cotton",
	"Flax",
	"Hemp",
	"Iron",
	"Incense",
	"Pelts",
	"Saltpeter",
	"Silk",
	"Timber",
	"Wool"
]

var spices = [
	"Allspice",
	"Cardomom",
	"Cinnamon",
	"Cloves",
	"Cocoa",
	"Cumin",
	"Ginger",
	"Mustard",
	"Nutmeg",
	"Opium",
	"Pepper",
	"Saffron",
	"Tobacco",
	"Turmeric",
	"Vanilla"
]
var treasure = [
	"Gems",
	"Gold",
	"Ivory",
	"Pearls",
	"Porcelain",
	"Silver"
]

var artikel_list = (
	foods +
	manufactured_goods +
	raw_materials +
	spices +
	treasure)

func get_color(artikel, artikel_price):
	if artikel_price >= base_price[artikel] * 1.3:
		return Color.red
	elif artikel_price > base_price[artikel] * 1.1 and artikel_price < base_price[artikel] * 1.3:
		return Color.firebrick
	elif artikel_price < base_price[artikel] * 0.9 and artikel_price > base_price[artikel] * 0.7:
		return Color.darkgreen
		
	elif artikel_price <= base_price[artikel] * 0.7:
		return Color.green
	return Color.goldenrod
var biome_tiles = {
	"alpine": [0, 1, 2, 3],
	"conifer": [4, 5, 6, 7],
	"desert": [8, 9, 10, 11],
	"forest": [12, 13, 14, 15],
	"grassland": [16, 17, 18, 19],
	"jungle": [20, 21, 22, 23],
	"lake": [24, 25, 26, 27],
	"ocean": [28, 29, 30, 31],
	"plains": [32, 33, 34, 35],
	"savannah": [60, 61, 62, 63],
	"sea": [36, 37, 38, 39],
	"shallows": [40, 41, 42, 43],
	"snowpack": [44, 45, 46, 47],
	"snowy tundra": [48, 49, 50, 51],
	"taiga": [52, 53, 54, 55],
	"tundra": [56, 57, 58, 59]}
func get_production(tile_id):
	for biome_type in biome_map.biome_tiles.keys():
		if tile_id in biome_map.biome_tiles[biome_type]:
			var artikel_str = $ByBiome.random_artikel(biome_type)
			return artikel_str
	
