extends CharacterBody3D

@export var speed := 10.0
@export var vertical_speed := 6.0
@export var acceleration := 10.0

var input_dir := Vector3.ZERO

func _physics_process(delta: float) -> void:
	var input_vec := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward := -transform.basis.z
	var right := -transform.basis.x
	
	var horizontal_dir := (forward * input_vec.y) + (right * input_vec.x)
	horizontal_dir = horizontal_dir.normalized()
	var up := Input.is_action_pressed("ascend")
	var down := Input.is_action_pressed("descend")
	var vertical_dir := 0.0
	
	if up:
		vertical_dir = 1.0
	elif down:
		vertical_dir = -1.0
		
	var target_velocity := horizontal_dir * speed
	target_velocity.y = vertical_dir * vertical_speed
	#smooth
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	move_and_slide()
