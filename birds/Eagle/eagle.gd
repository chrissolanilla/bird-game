extends CharacterBody3D

@export var fly_speed := 14.0
@export var vertical_speed := 10.0
@export var turn_speed := 6.0
@export var mouse_sens := 0.002
@onready var animation_tree: AnimationTree = $eaglewithanimation/AnimationTree
@onready var attack_timer: Timer = $attackTimer

@onready var yaw: Node3D = $Yaw
@onready var pitch: Node3D = $Yaw/Pitch
@onready var bird_mesh: Node3D =  $eaglewithanimation/Armature/Skeleton3D/eaglebody# your mesh root
@onready var animation_player: AnimationPlayer = $eaglewithanimation/AnimationPlayer
@onready var camera_3d: Camera3D = $Yaw/Pitch/Camera3D

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

enum {FLYING, ATTACK}

var flying_val:float =0
var attack_val :float=0
var current_anim = FLYING
var blend_speed = 15
func handle_anim(delta):
	match current_anim:
		FLYING:
			flying_val = lerpf(flying_val,1.0,blend_speed*delta)
			attack_val = lerp(attack_val,0.0, blend_speed*delta)
		ATTACK:
			flying_val = lerpf(flying_val,0.0,blend_speed*delta)
			attack_val = lerp(attack_val,1.0, blend_speed*delta)
var state := "Flying"
var current_delta

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_3d.current = is_multiplayer_authority()
	#self.rotation_degrees.y = 180	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Horizontal turn
		yaw.rotate_y(-event.relative.x * mouse_sens)

		# Camera pitch
		pitch.rotation.x += event.relative.y * mouse_sens
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		current_delta = delta
		if Input.is_action_just_pressed("ui_accept"):
			current_anim = ATTACK
			#handle_anim(delta)
			attack_val = 1
			update_tree()
			attack_timer.start()
			
		if Input.is_action_just_pressed("ui_cancel"):
			$"../".pause()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
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


func _on_attack_timer_timeout() -> void:
	attack_val = 0
	print("we timed out")
	flying_val =0
	update_tree()

func update_tree():
	animation_tree.set("parameters/takeOffFly/blend_amount",flying_val)
	animation_tree.set("parameters/Attack/blend_amount", attack_val)
	
