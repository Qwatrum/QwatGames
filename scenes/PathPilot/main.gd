extends Node2D

var selector_x = 0
var selector_y = 0

var buttons = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("down"):
		if selector_y != 2:
			selector_y += 1
			$"Selector".position.y += 110
	if Input.is_action_just_pressed("up"):
		if selector_y != 0:
			selector_y -= 1
			$"Selector".position.y -= 110
	if Input.is_action_just_pressed("left"):
		if selector_x != 0:
			selector_x -= 1
			$"Selector".position.x -= 134
	if Input.is_action_just_pressed("right"):
		if selector_x != 3:
			selector_x += 1
			$"Selector".position.x += 134

	
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/pathpilot/level"+str(buttons[selector_y][selector_x])+".tscn")
		
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
