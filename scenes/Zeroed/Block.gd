extends Node2D
var pattern
@onready var fields = [$"F1",$"F2",$"F3",$"F4",$"F5",$"F6",$"F7",$"F8",$"F9"]

func set_pattern(l):
	pattern = l
	
	var i = 0
	for number in l:
		if number == 0:
			fields[i].hide()
		else:
			fields[i].set_number(number)
			fields[i].show()
			#fields[i].set_color(Color(0.25,0.25,0.7))
		i += 1
	#print(pattern)

func get_pattern():
	return pattern
