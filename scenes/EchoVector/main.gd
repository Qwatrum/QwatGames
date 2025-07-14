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


var arena_selected = 1
var number_of_arenas = 5

func _ready():
	dir_absolute(save_file_path)
	load_scores()
	$"LeftArrow".hide()
	update_arena_card()

func _process(delta):
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
	if Input.is_action_just_pressed("right"):
		$"LeftArrow".show()
		if arena_selected != number_of_arenas:
			arena_selected += 1
			update_arena_card()
			if arena_selected == 5:
				$"RightArrow".hide()
				
	if Input.is_action_just_pressed("left"):
		$"RightArrow".show()
		if arena_selected != 1:
			arena_selected -= 1
			update_arena_card()
			if arena_selected == 1:
				$"LeftArrow".hide()
				
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/EchoVector/level"+str(arena_selected)+".tscn")

func update_arena_card():
	$"ArenaCard".set_arena_number(arena_selected)
	$"ArenaCard".set_arena_score(scores[arena_selected-1])
