extends Control

var artikels
var mouse_in = false
var quantity
var price
var artikel_str
signal hovered

func _ready():
	artikels = get_tree().root.get_node("Main/Artikels")

func connect_signals(exchange_node):
	connect(
		"hovered",
		exchange_node,
		"_on_ArtikelBox_hovered")

func load_artikel(name_str, q, p):
	artikel_str = name_str
	quantity = q
	price = p
	set_all()

func set_all():
	$Backing/ArtikelTexture.texture = load("res://Assets/Artikel/" + artikel_str + ".png")
	$Backing/QuantityLabel.text = str(quantity)
	$Backing/PriceLabel.text = str(price)
	$Backing/PriceLabel.modulate = artikels.get_color(artikel_str, price)

func _on_Backing_mouse_entered():
	mouse_in = true
	emit_signal("hovered", self)
	print("artikel Box Hovered")

func _on_Backing_mouse_exited():
	mouse_in = false
