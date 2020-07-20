extends Node2D

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
	"Cannon Balls": 150,
	"Canvas": 30,
	"Clothes": 75,
	"Fine Clothes": 350,
	"Gunpowder": 200,
	"Small Arms": 250,
	"Cotton": 100,
	"Dyes": 150,
	"Hemp": 50,
	"Iron": 200,
	"Leather": 80,
	"Linen": 125,
	"Pelts": 300,
	"Saltpeter": 120,
	"Silk": 325,
	"Timber": 80,
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
	"Copper": 300,
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
	"Rope",
	"Small Arms"
]


var raw_materials = [
	"Cotton",
	"Hemp",
	"Iron",
	"Leather",
	"Linen",
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
	"Mace",
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
	"Copper",
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
	
