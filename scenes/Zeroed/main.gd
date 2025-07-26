extends Node2D

var best_scores
var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)
func load_best_scores():
	if FileAccess.file_exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name)
		best_scores = data.zeroed_best_scores
	else:
		data.update_zeroed_best_scores_all(["/","/","/"])
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_best_scores()
func save_best_scores():
	data.update_info_shown(best_scores)
	ResourceSaver.save(data, save_file_path + save_file_name)
	
var selector_x = 0

func _ready():
	dir_absolute(save_file_path)
	load_best_scores()

	$"SelectorSound".play()
	$"BestScoreEasy".text = str(best_scores[0])
	$"BestScoreMedium".text = str(best_scores[1])
	$"BestScoreHard".text = str(best_scores[2])

func _process(_delta):
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
	if Input.is_action_just_pressed("right"):
		if selector_x != 2:
			selector_x += 1
			$"Selector".position.x += 212.5
			$"SelectorSound".play()
			
	if Input.is_action_just_pressed("left"):
		if selector_x != 0:
			selector_x -= 1
			$"Selector".position.x -= 212.5
			$"SelectorSound".play()
		
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/Zeroed/level"+str(selector_x+1)+".tscn")
