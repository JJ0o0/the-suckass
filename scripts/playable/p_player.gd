extends CharacterBody3D

@onready var head: Node3D = $head
@onready var m_camera: Camera3D = $head/m_camera

@export var speed : float = 3.0
@export var smooth_factor : float = 10.0
@export var Sensivity : float = 5
@export var amplitude : float = 0.05
@export var frequency : float = 2.0

var sensivity : float
var bob_time : float

var input_direction : Vector2

var can_move : bool = false
var can_look : bool = false

func _ready() -> void:
	PlayerAutoload.player = self
	GameManager.player = self
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	sensivity = Sensivity / 1000

func _unhandled_input(event: InputEvent) -> void:
	if not can_look:
		return
	
	_look(event)

func _process(delta: float) -> void:
	_detect_dialogue_mode(delta)

func _physics_process(delta : float) -> void:
	if not can_move:
		return
	
	_move(delta)
	_headbob(delta)
	
	move_and_slide()

func _move(delta : float) -> void:
	if not is_on_floor() and not GameManager.debug_mode:
		velocity += get_gravity() * delta
	
	input_direction = Input.get_vector("left", "right", "forward", "backward")
	var direction : Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * smooth_factor)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * smooth_factor)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * smooth_factor)
		velocity.z = lerp(velocity.z, 0.0, delta * smooth_factor)
func _look(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			return
		
		rotate_y(-event.relative.x * sensivity)
		head.rotate_x(-event.relative.y * sensivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))
func _headbob(delta : float) -> void:
	bob_time += delta * velocity.length() * int(is_on_floor())
	
	var bob : Vector3 = Vector3.ZERO
	bob.x = cos(bob_time * frequency / 2) * amplitude
	bob.y = sin(bob_time * frequency) * amplitude
	bob.z = 0
	
	var target = bob if _is_moving() else Vector3.ZERO
	
	m_camera.position = lerp(m_camera.position, target, 0.01)
func _detect_dialogue_mode(delta : float) -> void:
	if not GameManager.dialogue_mode:
		can_move = true
		can_look = true
		
		return
	
	can_move = false
	can_look = false
	
	if GameManager.dialogue_mode_move_camera:
		var pos = GameManager.dialogue_obj.global_position
		basis = basis.slerp(transform.looking_at(pos).basis, delta * 3)
func _is_moving() -> bool:
	return velocity.length() > 1.0 && not GameManager.dialogue_mode
