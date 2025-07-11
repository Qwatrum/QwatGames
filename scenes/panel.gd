extends Panel

@export var title = ""
@export var image_path = ""


func _ready():
	$"Title".text = title
	var texture = load("res://assets/game_images/"+image_path)
	$"TextureRect".texture = texture
