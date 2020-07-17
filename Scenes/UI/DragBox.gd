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
	$Backing/ArtikelTexture.texture = load("res://Assets/Artikel/" + artikel_str + ".png")
	$Backing/QuantityLabel.text = str(quantity)
	$Backing/PriceBacking.hide()
	$Backing/PriceLabel.hide()
