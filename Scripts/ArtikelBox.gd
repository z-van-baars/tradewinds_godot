extends Control


func _process(delta):
	$HoverBox.rect_position = get_viewport().get_mouse_position()

func _on_Backing_mouse_entered():
	$HoverTimer.start()


func _on_Backing_gui_input(event):
	if event == InputEvent.MOUSE_MOTION:
		$HoverTimer.restart()
		$HoverBox.hide()


func _on_HoverTimer_timeout():
	$HoverBox.show()
