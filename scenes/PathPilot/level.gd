extends Node2D

@export var level_number = 0
var directions = []

var ended = false

func _ready():
	await get_tree().create_timer(2).timeout
	$"Camera2D/Intro".hide()

func game_over():
	$"Camera2D/GO".show()

func win():
	$"Camera2D/WIN".show()
	
func done():
	ended = true
	await get_tree().create_timer(0.5).timeout
	if $"Player".position == $"Goal".position:
		$"Player".hide()
		$"Camera2D/WIN".show()

	else:
		$"Camera2D/GO".show()

func _process(delta):
	
	if Input.is_action_just_pressed("down"):
		directions.append(Vector2.DOWN)
	if Input.is_action_just_pressed("up"):
		directions.append(Vector2.UP)
	if Input.is_action_just_pressed("left"):
		directions.append(Vector2.LEFT)
	if Input.is_action_just_pressed("right"):
		directions.append(Vector2.RIGHT)
	
	if Input.is_action_just_pressed("confirm"):
		if not ended:
			$"Player".directions = directions
			$"Player".started = true
		else:
			get_tree().change_scene_to_file("res://scenes/pathpilot/level"+str(level_number)+".tscn")
		
	if Input.is_action_just_pressed("leave"):
		get_tree().change_scene_to_file("res://scenes/pathpilot/main.tscn")
