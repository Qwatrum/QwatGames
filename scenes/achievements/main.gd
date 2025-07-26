extends Node2D

var achievements
var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)
func load_achievements():
	if FileAccess.file_exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name)
		achievements = data.achievements
	else:
		data.update_echovector_scores(false)
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_achievements()
	
func _ready():
	dir_absolute(save_file_path)
	load_achievements()
	
	$"SelectorSound".play()
	
	if len(achievements) == 0:
		$"ScrollContainer/Text1".text += "\nYou don't have any achievements yet."
	else:
		for a in achievements:
			$"ScrollContainer/Text1".text += "\n" + a

func _process(_delta):
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
