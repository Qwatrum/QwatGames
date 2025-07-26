extends Node2D


var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)

func reset_all_data():
	data.update_info_shown(true)
	data.update_neonrush_time(["-","-","-","-","-"])
	data.update_completed_levels([])
	data.update_zeroed_best_scores_all(["/","/","/"])
	data.achievements = []
	ResourceSaver.save(data, save_file_path + save_file_name)
	
var selector_index = 0

func _ready():
	dir_absolute(save_file_path)
	$"SelectorSound".play()

func _process(_delta):
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
	if Input.is_action_just_pressed("right"):
		if selector_index != 1:
			selector_index += 1
			$"SelectorSound".play()
			$"Selector".position.x += 325
	if Input.is_action_just_pressed("left"):
		if selector_index != 0:
			selector_index -= 1
			$"SelectorSound".play()
			$"Selector".position.x -= 325
	if Input.is_action_just_pressed("confirm"):
		if selector_index == 0:
			get_tree().change_scene_to_file("res://scenes/how_to/Howto.tscn")
		elif selector_index == 1:
			reset_all_data()
			$"DataGone".show()
			$"SelectorSound".play()
