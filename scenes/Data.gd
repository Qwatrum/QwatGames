extends Resource
class_name Data

@export var info_shown = false

@export var neonrush_times = ["-","-","-","-","-"]

@export var completed_levels = []

@export var zeroed_best_scores = ["/","/","/"]

@export var achievements = []

func update_info_shown(update_to):
	info_shown = update_to

func update_neonrush_time(new_list):
	neonrush_times = new_list

func update_completed_levels(new_list):
	completed_levels = new_list

func update_zeroed_best_scores(new_item):
	zeroed_best_scores[new_item[0]] = new_item[1]

func update_zeroed_best_scores_all(a):
	zeroed_best_scores = a

func update_achievements(new_one):
	achievements.append(new_one)
