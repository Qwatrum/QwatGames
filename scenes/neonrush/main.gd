extends Node2D


var arena_selected = 1
var number_of_arenas = 5

func _ready():

	$"LeftArrow".hide()
	update_arena_card()
	$"SelectorSound".play()

func _process(_delta):
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
	if Input.is_action_just_pressed("right"):
		$"LeftArrow".show()
		if arena_selected != number_of_arenas:
			arena_selected += 1
			update_arena_card()
			$"SelectorSound".play()
			if arena_selected == 5:
				$"RightArrow".hide()
				
	if Input.is_action_just_pressed("left"):
		$"RightArrow".show()
		if arena_selected != 1:
			arena_selected -= 1
			update_arena_card()
			$"SelectorSound".play()
			if arena_selected == 1:
				$"LeftArrow".hide()
				
	

func update_arena_card():
	$"ArenaCard".set_arena_number(arena_selected)

