extends Node2D

var scores
var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)
func load_scores():
	if FileAccess.file_exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name)
		scores = data.echovector_scores
	else:
		data.update_echovector_scores(false)
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_scores()
func save_scores():
	data.update_echovector_scores(scores)
	ResourceSaver.save(data, save_file_path + save_file_name)


func _ready():
	dir_absolute(save_file_path)
	load_scores()


func _process(delta):
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/EchoVector/main.tscn")
