extends Panel

@export var number = 0

func _ready():
	$"LevelNumber".text = str(number)
	$"Completed".hide()

func show_completed():
	$"Completed".show()
