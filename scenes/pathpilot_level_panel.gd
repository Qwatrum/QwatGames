extends Panel

@export var number = 0

func _ready():
	$"LevelNumber".text = str(number)
