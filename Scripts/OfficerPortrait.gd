extends Control

var officer = null

func load_officer(character):
	officer = character
	$HoverBox/AgeLabel.text = ("Age " + character.get_age())
	$HoverBox/NameLabel.text = character.get_name()
	$TitleLabel.text = character.title

func _on_Background_mouse_entered():
	$HoverBox.show()


func _on_Background_mouse_exited():
	$HoverBox.hide()
