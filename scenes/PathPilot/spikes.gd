extends Node2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		get_parent().game_over()
