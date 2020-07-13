extends Node2D

var interaction_queue = []
signal open_encounter_screen

func _on_Ship_target_entity_reached(targeting_entity, target_character, target_entity):
	if targeting_entity.player_ship == true:
		emit_signal("open_encounter_screen", target_character, target_entity)
	else:
		resolve_interaction(targeting_entity, target_character, target_entity)

func resolve_interaction(targeting_entity, target_character, target_entity):
	pass
