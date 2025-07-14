extends Resource
class_name Data

@export var info_shown = false

@export var echovector_scores = ["-","-","-","-","-"]

func update_info_shown(update_to):
	info_shown = update_to

func update_echovector_scores(update_element):
	echovector_scores[update_element[0]] = update_element[1]
