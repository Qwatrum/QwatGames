extends Node2D

var completed_levels

var save_file_path = "user://save"
var save_file_name = "DataSaver.tres"
var data = Data.new()
func dir_absolute(path):
	DirAccess.make_dir_absolute(path)
func load_c_levels():
	if FileAccess.file_exists(save_file_path + save_file_name):
		data = ResourceLoader.load(save_file_path + save_file_name)
		completed_levels = data.completed_levels
	else:
		data.update_completed_levels(false)
		ResourceSaver.save(data, save_file_path + save_file_name)
		load_c_levels()
	
var selector_x = 0
var selector_y = 0

var buttons = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]

func _ready():
	dir_absolute(save_file_path)
	load_c_levels()
	$"SelectorSound".play()
	var x = 1
	for c in $"Row1".get_children():
		if x in completed_levels:
			c.show_completed()
		x+=1
	for c in $"Row2".get_children():
		if x in completed_levels:
			c.show_completed()
		x+=1
	for c in $"Row3".get_children():
		if x in completed_levels:
			c.show_completed()
		x+=1

func _process(_delta):
	if Input.is_action_just_pressed("down"):
		if selector_y != 2:
			selector_y += 1
			$"Selector".position.y += 110
			$"SelectorSound".play()
	if Input.is_action_just_pressed("up"):
		if selector_y != 0:
			selector_y -= 1
			$"Selector".position.y -= 110
			$"SelectorSound".play()
	if Input.is_action_just_pressed("left"):
		if selector_x != 0:
			selector_x -= 1
			$"Selector".position.x -= 134
			$"SelectorSound".play()
	if Input.is_action_just_pressed("right"):
		if selector_x != 3:
			selector_x += 1
			$"Selector".position.x += 134
			$"SelectorSound".play()

	
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/PathPilot/level"+str(buttons[selector_y][selector_x])+".tscn")
		
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
