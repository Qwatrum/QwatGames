extends Node2D
var state = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		state = !state
		$"LeverSound".play()
		get_parent().box_hide(state)
		if state:
			$"AnimatedSprite2D".frame = 1
		else:
			$"AnimatedSprite2D".frame = 0
