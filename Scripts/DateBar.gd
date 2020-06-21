extends ColorRect
var player

func _ready():
	player = get_tree().root.get_node("Main/Player")

func _process(delta):
	$SilverLabel.text = str(player.silver)


func _on_Calendar_date_changed(date_string):
	$DateLabel.text = "Date ~ " + date_string
