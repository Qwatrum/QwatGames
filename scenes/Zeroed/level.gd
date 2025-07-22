extends Node2D
@onready var nextups = [$"NextUp1",$"NextUp2",$"NextUp3"]
@onready var fields = [$"Fields/F1",$"Fields/F2",$"Fields/F3",$"Fields/F4",$"Fields/F5",$"Fields/F6",$"Fields/F7",$"Fields/F8",$"Fields/F9",$"Fields/F10",$"Fields/F11",$"Fields/F12",$"Fields/F13",$"Fields/F14",$"Fields/F15",$"Fields/F16"]
@onready var block_node = $"Block"

var state = 0 # 0: block selection, 1: block placement
var values = [7,7,7,7,6,6,6,6,1,1,1,1,2,2,9,9]
var block_patterns = [[0,1,2,3,0,0,7,9,0],[1,1,1,0,0,0,0,0,0],[0,0,0,0,0,0,0,9,0],[1,1,1,1,1,1,1,1,1]]

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
	#print(max_block_x)
	#print(max_block_y)
	#print(min_block_x)
	#print(min_block_y)
	
	
	block_node.set_pattern(current_pattern)
	
func place_block():
	var place_pattern = current_pattern
	print(current_pattern)
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
			#print(values[index])
			#print(value)
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
			print("DONE")
			$"Completed".show()
			$"BlockSelector".position = Vector2(999,999)
			$"HSeparator2".hide()
			$"HSeparator".hide()
			$"VSeparator".hide()
			state = 2
		

func create_field():
	var i = 0
	for e in fields:
		e.set_number(values[i])
		i+=1
