extends Node2D
@export var difficulty = 0
@onready var nextups = [$"NextUp1",$"NextUp2",$"NextUp3"]
@onready var fields = [$"Fields/F1",$"Fields/F2",$"Fields/F3",$"Fields/F4",$"Fields/F5",$"Fields/F6",$"Fields/F7",$"Fields/F8",$"Fields/F9",$"Fields/F10",$"Fields/F11",$"Fields/F12",$"Fields/F13",$"Fields/F14",$"Fields/F15",$"Fields/F16"]
@onready var block_node = $"Block"


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
	data.update_zeroed_best_scores_all(best_scores)
	ResourceSaver.save(data, save_file_path + save_file_name)

var state = 0 # 0: block selection, 1: block placement
var values = []
var original_values = values
var block_patterns = []

var done_count = 0

var block_selector_y = 0

var current_pattern

var block_x
var block_y

var max_block_x
var max_block_y

var min_block_x
var min_block_y

func _ready():
	dir_absolute(save_file_path)
	load_best_scores()
	print(best_scores)
	create_field()
	$"SelectorSound".play()
	$"Completed".hide()
	block_node.hide()
	for i in range(3):
		new_block()
		block_selector_y += 1
	block_selector_y = 0
	

func _process(delta):
	
	if Input.is_action_just_pressed("up"):
		if state == 0:
			if block_selector_y != 0:
				$"BlockSelector".position.y -= 134
				block_selector_y -= 1
				$"SelectorSound".play()
		if state == 1:
			if block_y > min_block_y:
				block_node.position.y -= 100
				block_y -= 1
				
	if Input.is_action_just_pressed("down"):
		if state == 0:
			if block_selector_y != 2:
				$"BlockSelector".position.y += 134
				block_selector_y += 1
				$"SelectorSound".play()
		if state == 1:
			if block_y < max_block_y:
				block_node.position.y += 100
				block_y += 1
				
	if Input.is_action_just_pressed("left"):
		if state == 1:
			if block_x > min_block_x:
				block_node.position.x -= 100
				block_x -= 1
				
	if Input.is_action_just_pressed("right"):
		if state == 1:
			if block_x < max_block_x:
				block_node.position.x += 100
				block_x += 1
	
	if Input.is_action_just_pressed("confirm"):
		if state == 0:
			if nextups[block_selector_y].is_visible_in_tree():
				state = 1
				create_block()
				$"BlockSelector".hide()
				$"SelectorSound".play()
			
			
		elif state == 1:
			state = 0
			place_block()
			$"BlockSelector".show()
			$"SelectorSound".play()
		
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/Zeroed/main.tscn")

func create_max_min_xy():
	if current_pattern[2] != 0 or current_pattern[5] != 0 or current_pattern[8] != 0:
		max_block_x = 1
	elif current_pattern[1] != 0 or current_pattern[4] != 0 or current_pattern[7] != 0:
		max_block_x = 2
	else:
		max_block_x = 3
		
	if current_pattern[6] != 0 or current_pattern[7] != 0 or current_pattern[8] != 0:
		max_block_y = 1
	elif current_pattern[3] != 0 or current_pattern[4] != 0 or current_pattern[5] != 0:
		max_block_y = 2
	else:
		max_block_y = 3
		
	if current_pattern[0] != 0 or current_pattern[3] != 0 or current_pattern[6] != 0:
		min_block_x = 0
	elif current_pattern[1] != 0 or current_pattern[4] != 0 or current_pattern[7] != 0:
		min_block_x = -1
	else:
		min_block_x = -2
		
	if current_pattern[0] != 0 or current_pattern[1] != 0 or current_pattern[2] != 0:
		min_block_y = 0
	elif current_pattern[3] != 0 or current_pattern[4] != 0 or current_pattern[5] != 0:
		min_block_y = -1
	else:
		min_block_y = -2

func create_block():
	block_node.show()
	block_node.position = Vector2(32,50)
	nextups[block_selector_y].hide()
	block_x = 0
	block_y = 0
	current_pattern = nextups[block_selector_y].get_pattern()
	create_max_min_xy()
	
	
	block_node.set_pattern(current_pattern)
	
func place_block():
	var place_pattern = current_pattern
	for i in range(3):
		for j in range(3):
			var value = place_pattern[i * 3 + j]
			if value == 0:
				continue
				
			var field_x = block_x + j
			var field_y = block_y + i
			
			if field_x < 0 or field_x >= 4 or field_y < 0 or field_y >=4:
				continue
			
			var index = field_y * 4 + field_x
			values[index]-=value
			fields[index].set_number(values[index])
	
	block_node.hide()
	new_block()

func new_block():
	if len(block_patterns) != 0:
		nextups[block_selector_y].set_pattern(block_patterns[0])
		block_patterns.remove_at(0)
		nextups[block_selector_y].show()
	else:
		done_count += 1
		if done_count == 3:
			$"Completed".show()
			$"BlockSelector".position = Vector2(999,999)
			$"HSeparator2".hide()
			$"HSeparator".hide()
			$"VSeparator".hide()
			state = 2
			var score = calculate_score()
			$"Completed".text += "\n"+score[0]
			if difficulty == 0:
				if int(score[1]) < int(best_scores[0]) or str(best_scores[0]) == "/":
					best_scores[0] = score[1]
					save_best_scores()
			elif difficulty == 2:
				if int(score[1]) < int(best_scores[1]) or str(best_scores[1]) == "/":
					best_scores[1] = score[1]
					save_best_scores()
			elif difficulty == 6:
				if int(score[1]) < int(best_scores[2]) or str(best_scores[2]) == "/":
					best_scores[2] = score[1]
					save_best_scores()

func create_field():
	var number_of_blocks = randi_range(3+difficulty,5+difficulty)
	
	for i in range(16):
		values.append(0)
	for i in range(number_of_blocks):
		var numbers = []
		for j in range(9):
			if randi_range(0,2) == 0:
				numbers.append(0)
			else:
				numbers.append(randi_range(1,10))
		if numbers.max() == 0:
			numbers.remove_at(0)
			numbers.append(randi_range(1,10))
			numbers.shuffle()
		block_patterns.append(numbers)
	
		var max_x = 1
		var max_y = 1
		var rand_x = randi_range(0,1)
		var rand_y = randi_range(0,1)
		for y in range(3):
			for x in range(3):
				var val = numbers[y*3+x]
				if val == 0:
					continue
				var field_x = rand_x + x
				var field_y = rand_y + y
				var index = field_y * 4 + field_x
				values[index] += val
		

	for i in range(16):
		fields[i].set_number(values[i])


func calculate_score():
	var difficulties = ["Easy","","Medium","","","","Hard"]
	var sum = 0
	var scores = []
	var max_abs_value = values.max()
	for e in values:
		sum += abs(e)
	if sum == 0:
		return ["Perfect!\n100%"+"\n"+difficulties[difficulty]+" mode",0]
	else:
		return ["Off-Zero score:\n"+str(sum)+"\n"+difficulties[difficulty]+" mode",sum]
