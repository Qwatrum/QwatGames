extends Panel

@export var title = ""
@export var image_path = ""
@export var color = ""


func _ready():
	$"Title".text = title
	var texture = load("res://assets/menu_images/"+image_path)
	$"TextureRect".texture = texture
	$"ColorRect".color = color
