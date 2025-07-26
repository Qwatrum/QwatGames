extends Node2D

# Data saving. The info screen is just shown when the game is opened for the first time
var info_shown
var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)
func load_info_shown():
	if FileAccess.file_exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name)
		info_shown = data.info_shown
	else:
		data.update_info_shown(false)
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_info_shown()
func save_info_shown():
	data.update_info_shown(info_shown)
	ResourceSaver.save(data, save_file_path + save_file_name)


var selector_x = 0
var selector_y = 0

var buttons = [["PathPilot", "Zeroed", "neonrush", "echovector"],["achievements", "info"]]

func _ready():
	dir_absolute(save_file_path)
	load_info_shown()
	
	if not info_shown:
		info_shown = true
		save_info_shown()
		
		get_tree().change_scene_to_file("res://scenes/info/main.tscn")
	
	$"SelectorSound".play()

func _process(_delta):
	if Input.is_action_just_pressed("down"):
		if selector_x <= 1:
			if selector_y != 1:
				selector_y = 1
				$"Selector".position.y += 150
				$"SelectorSound".play()
	if Input.is_action_just_pressed("up"):
		if selector_y != 0:
			selector_y = 0
			$"Selector".position.y -= 150
			$"SelectorSound".play()
	if Input.is_action_just_pressed("left"):
		if selector_x != 0:
			selector_x -= 1
			$"Selector".position.x -= 134
			$"SelectorSound".play()
	if Input.is_action_just_pressed("right"):
		if selector_y == 0:
			if selector_x != 2:
				selector_x += 1
				$"Selector".position.x += 134
				$"SelectorSound".play()
		elif selector_y == 1:
			if selector_x != 1:
				selector_x += 1
				$"Selector".position.x += 134
				$"SelectorSound".play()
	
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/"+buttons[selector_y][selector_x]+"/main.tscn")
