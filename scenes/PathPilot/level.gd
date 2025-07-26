extends Node2D

@export var level_number = 0
@export var number_of_gems = 0

var directions = []

var ended = false

var gems_collected = 0

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
func save_c_levels():
	data.update_completed_levels(completed_levels)
	ResourceSaver.save(data, save_file_path + save_file_name)

func _ready():
	dir_absolute(save_file_path)
	load_c_levels()
	$"Camera2D/Intro".show()
	await get_tree().create_timer(2).timeout
	$"Camera2D/Intro".hide()

func game_over():
	ended = true
	$"Camera2D/GO".show()
	$"Player".started = false
	$"LooseSound".play()

func gem_collected():
	gems_collected += 1
	$"GemSound".play()
	
func box_hide(b):
	for c in $"Boxes".get_children():
		if b:
			c.box_hide()
		else:
			c.call_deferred("box_show")
	


func done():
	ended = true
	await get_tree().create_timer(0.5).timeout
	if $"Player".position == $"Goal".position and gems_collected == number_of_gems:
		$"Player".hide()
		$"Camera2D/WIN".show()
		$"SuccesSound".play()
		if level_number not in completed_levels:
			completed_levels.append(level_number)
			save_c_levels()
		
	else:
		$"Camera2D/GO".show()
		$"LooseSound".play()
		$"Player".started = false

func _process(_delta):
	
	if Input.is_action_just_pressed("down"):
		directions.append(Vector2.DOWN)
		$"InputSound".play()
	if Input.is_action_just_pressed("up"):
		directions.append(Vector2.UP)
		$"InputSound".play()
	if Input.is_action_just_pressed("left"):
		directions.append(Vector2.LEFT)
		$"InputSound".play()
	if Input.is_action_just_pressed("right"):
		directions.append(Vector2.RIGHT)
		$"InputSound".play()
	
	if Input.is_action_just_pressed("confirm"):
		if not ended:
			$"Player".directions = directions
			$"Player".started = true
			$"StartSound".play()
		else:
			get_tree().change_scene_to_file("res://scenes/PathPilot/level"+str(level_number)+".tscn")
		
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/PathPilot/main.tscn")
