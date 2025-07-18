extends StaticBody2D


func box_hide():
	$"AnimatedSprite2D".frame = 1
	await get_tree().create_timer(0.3).timeout
	$"CollisionShape2D".disabled = true
	hide()
	
func box_show():
	$"AnimatedSprite2D".frame = 0
	$"CollisionShape2D".disabled = false
	show()
	
