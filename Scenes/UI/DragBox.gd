extends Control

var quantity
var artikel_str
var taking = false

func load_artikel(name_str, q, to_take):
	artikel_str = name_str
	quantity = q
	taking = to_take
	set_all()

func set_all():
	var formatted_string = artikel_str.replace(" ", "_")
	$Backing/ArtikelTexture.texture = load("res://Assets/Artikel/" + formatted_string + ".png")
	$Backing/QuantityLabel.text = str(quantity)
	$Backing/PriceBacking.hide()
	$Backing/PriceLabel.hide()
