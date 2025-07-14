extends CharacterBody2D

const SPEED = 500.0
const ACCEL = 2.0
var rot = 0
var input: Vector2
var points = 0

var stopped = false
var health = 100

var level

func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	return input.normalized()
	
func turn_to_mouse():
	var direction_vector = position - get_global_mouse_position()
	direction_vector = direction_vector.normalized()
	
	var angle = atan2(direction_vector.y, direction_vector.x)
	rot = rad_to_deg(angle) - 90
	$"Sprite2D".rotation_degrees = rot
func shoot():
	pass
	
func _process(delta):
	if not stopped:
		var playerInput = get_input()
		velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
		turn_to_mouse()
		move_and_slide()
	if health < 0 and not stopped:
		hide()
		stopped = true
		
	if Input.is_action_just_pressed("confirm"):
		shoot()



func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		health -= 25
		body.queue_free()
