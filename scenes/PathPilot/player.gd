extends CharacterBody2D

const MOVE_AMOUNT := 20

var directions = []

var move_index = 0
var move_timer = 0.4
var timer = 0.0

var started = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("spikes"):
		get_parent().game_over()
		move_index = directions.size()+1

func _physics_process(delta):
	if started:
		if move_index >= directions.size():
			get_parent().done()
			started = false
			return
		
		timer += delta
		
		if timer < move_timer:
			return
		
		timer = 0.0
		
		var dir = directions[move_index]
		var motion = dir.normalized() * MOVE_AMOUNT
		
		if not test_move(global_transform, motion):
			move_and_collide(motion)
		else:
			print("ouch")
		move_index += 1
