extends ColorRect
var player

func _ready():
	player = get_tree().root.get_node("Main/Player")

func _process(delta):
	$SilverLabel.text = "Silver: "+ str(player.silver)
