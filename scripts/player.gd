extends CharacterBody3D

const ACCELERATION = 45.0
const DECELERATION = 20.0
const SPEED = 5.0
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 5.6
const SENSITIVITY = 0.01

const BOB_FREQUENCY = 4.0
const BOB_AMPLITUDE = 0.04
var t_bob = 0.0

var gravity = 15.0
var menu_open := false
var camera_start_pos: Vector3

@onready var head = $Head
@onready var camera = $Head/Camera3D

@export_range(50.0, 120.0, 1.0) var normal_fov: float = 120.0
@export var sprint_fov_bonus: float = 15.0
@export var fov_transition_speed: float = 8.0

var checkpoint_position: Vector3
var respawn_height: float = -50.0


func _ready() -> void:
	checkpoint_position = global_position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_start_pos = camera.position
	camera.fov = normal_fov


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Menu"):
		toggle_menu()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not menu_open:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)


func _physics_process(delta: float) -> void:
	
	if global_position.y < respawn_height:
		respawn()
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var current_speed = SPEED
	var target_fov = normal_fov

	if Input.is_action_pressed("Sprint"):
		current_speed = SPRINT_SPEED
		target_fov = normal_fov + sprint_fov_bonus

	if direction:
		velocity.x = move_toward(velocity.x, direction.x * current_speed, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * current_speed, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, direction.x * current_speed, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * current_speed, DECELERATION * delta)

	# HEAD BOB
	t_bob += delta * Vector2(velocity.x, velocity.z).length() * float(is_on_floor())
	camera.position = camera_start_pos + _headbob(t_bob)
	
	camera.fov = lerp(camera.fov, target_fov, fov_transition_speed * delta)

	move_and_slide()


func toggle_menu() -> void:
	menu_open = not menu_open

	if menu_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func respawn():
	global_position = checkpoint_position
	velocity = Vector3.ZERO


func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY / 2.0) * BOB_AMPLITUDE
	return pos
