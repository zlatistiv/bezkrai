class_name Person
extends CharacterBody2D

@export var speed = 150
var is_player = true

func get_input():
	var input_direction
	
	if is_player:
		input_direction = Input.get_vector("left", "right", "up", "down")
	else:
		input_direction = Vector2(0, 0)
		
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	
