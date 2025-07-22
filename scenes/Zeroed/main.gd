extends Node2D

func _ready():
	$"SelectorSound".play()

func _process(delta):
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
		
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/Zeroed/level1.tscn")
