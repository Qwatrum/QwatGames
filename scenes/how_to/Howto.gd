extends Node2D
func _ready():
	$"SelectorSound".play()

func _process(_delta):
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/info/main.tscn")
