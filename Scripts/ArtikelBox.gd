extends Control

var artikels
var mouse_in = false
var quantity
var price
var artikel_str
var taking = false
signal hovered
signal clicked

func _ready():
	artikels = get_tree().root.get_node("Main/Artikels")

func connect_signals(exchange_node):
	connect(
		"hovered",
		exchange_node,
		"_on_ArtikelBox_hovered")
	connect("clicked",
		exchange_node,
		"_on_ArtikelBox_clicked")

func set_price_color(color):
	$Backing/PriceLabel.modulate = color

func load_artikel(name_str, q, p, to_take=false):
	artikel_str = name_str
	quantity = q
	price = p
	taking = to_take
	set_all()

func set_all():
	$Backing/ArtikelTexture.texture = load("res://Assets/Artikel/" + artikel_str + ".png")
	$Backing/QuantityLabel.text = str(quantity)
	if quantity > 999:
		$Backing/QuantityBacking.rect_size.x = 42
		$Backing/QuantityBacking.rect_position.x = 26
	elif quantity > 99 and quantity <= 999:
		$Backing/QuantityBacking.rect_size.x = 32
		$Backing/QuantityBacking.rect_position.x = 36
	elif quantity > 9 and quantity <= 99:
		$Backing/QuantityBacking.rect_size.x = 24
		$Backing/QuantityBacking.rect_position.x = 44
	elif quantity < 9:
		$Backing/QuantityBacking.rect_size.x = 16
		$Backing/QuantityBacking.rect_position.x = 52
	$Backing/PriceLabel.text = str(price)
	$Backing/PriceLabel.modulate = artikels.get_color(artikel_str, price)

func _on_Backing_mouse_entered():
	mouse_in = true
	emit_signal("hovered", self)

func _on_Backing_mouse_exited():
	mouse_in = false


func _on_Backing_gui_input(event):
	if event.is_action_pressed("left_click"):
		emit_signal("clicked", self)
