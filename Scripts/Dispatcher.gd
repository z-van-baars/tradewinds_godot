extends Node2D

var interaction_queue = []
signal open_encounter_screen

func _on_Ship_target_entity_reached(target_entity):
	emit_signal("open_encounter_screen", target_entity)
