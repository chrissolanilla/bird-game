extends CharacterBody3D

@export var fly_speed := 14.0
@export var vertical_speed := 10.0
@export var turn_speed := 6.0
@export var mouse_sens := 0.002

@onready var yaw: Node3D = $Yaw
@onready var pitch: Node3D = $Yaw/Pitch
@onready var bird_mesh: Node3D = $Mesh  # your mesh root

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#self.rotation_degrees.y = 180	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Horizontal turn
		yaw.rotate_y(-event.relative.x * mouse_sens)

		# Camera pitch
		pitch.rotation.x += event.relative.y * mouse_sens
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta: float) -> void:
	var input_vec := Input.get_vector("move_right", "move_left", "move_back", "move_forward")
	# Forward/right relative to camera yaw
	var forward := yaw.transform.basis.z
	var right := yaw.transform.basis.x
	# Horizontal direction
	var horizontal := (forward * input_vec.y) + (right * input_vec.x)
	horizontal = horizontal.normalized()
	# Vertical
	var vertical := 0.0
	if Input.is_action_pressed("ascend"):
		vertical = 1.0
	elif Input.is_action_pressed("descend"):
		vertical = -1.0
	# Total movement vector
	var move_dir := horizontal * fly_speed
	move_dir.y = vertical * vertical_speed
	# Smooth acceleration
	velocity = velocity.lerp(move_dir, 10.0 * delta)
	move_and_slide()
	# Smoothly rotate the bird mesh toward flight direction
	if velocity.length() > 0.1:
		var target_basis := Basis().looking_at(-velocity.normalized(), Vector3.UP)
		bird_mesh.basis = bird_mesh.basis.slerp(target_basis, turn_speed * delta)
