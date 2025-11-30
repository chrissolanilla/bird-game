extends CharacterBody3D

@export var speed := 10.0
@export var vertical_speed := 6.0
@export var acceleration := 10.0
@onready var camera_3d: Camera3D = $Camera3D


@export var mouse_sens := 0.005
var input_dir := Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	342
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotation.y -= event.relative.x * mouse_sens
		self.rotation.x -= event.relative.y * mouse_sens

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
