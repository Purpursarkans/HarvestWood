extends CharacterBody3D

const mix_view : float = -PI/2
const max_view : float = PI/2

var rot_x : float = 0
var rot_y : float = 0
var GUIVISIBLE : bool = true

const JUMP_VELOCITY : int = 5

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var PlayerRayCast : RayCast3D = $Head/PlayerRayCast3D

var haveLog : bool = false

func _ready():
	Engine.time_scale = 1
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var window_size = DisplayServer.window_get_size()
	lastMousePosition = window_size/2

var action_object = null

func actionLeft():
	action_object = PlayerRayCast.get_collider()
	actionLeftCursor(action_object)

func actionRight():
	action_object = PlayerRayCast.get_collider()
	actionRightCursor(action_object)

func actionLeftCursor(action_object):
	if action_object != null:
		#print_debug(action_object.name, "\tclick")
		if action_object.get_meta("LeftClick") == true:
			#print_debug("object have meta leftClick")
			action_object.leftClick()
			
func actionRightCursor(action_object):
	if action_object != null:
		#print_debug(action_object.name, "\tclick")
		if action_object.get_meta("rightClick") == true:
			#print_debug("object have meta rightClick")
			action_object.rightClick()

var Flash : bool = true

func _physics_process(delta):

	if Input.is_action_pressed("esc"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("e"):
		changeMouse()
	
	var SPEED : float = 5.0
	const SPEED_UP : float = 2
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("shift"):
		SPEED *= SPEED_UP
	
	var input_dir : Vector2 = Input.get_vector("a", "d", "w", "s")
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()



func _input(e):
	if !showCursor:
		if e is InputEventMouseMotion:
			rot_x -= e.relative.y * G.Sensivity * G.FixSensivity
			rot_y = -e.relative.x * G.Sensivity * G.FixSensivity
			
			#transform.basis = Basis(Vector3(0,1,0), rot_y) * transform.basis
			transform.basis = transform.basis.rotated(Vector3(0,1,0), rot_y)
			
			if rot_x <= max_view && rot_x >= mix_view:
				$Head.transform.basis = Basis(Vector3(1,0,0), rot_x)

			if rot_x > max_view: rot_x = max_view
			elif rot_x < mix_view: rot_x = mix_view
		
		if e is InputEventMouse:
			if e.is_action_pressed("leftMouse"):
				actionLeft()
			elif e.is_action_pressed("rightMouse"):
				actionRight()
	if showCursor:
		if e is InputEventMouse:
			if e.is_action_pressed("leftMouse"):
				mouseClick(e,"left")
			elif e.is_action_pressed("rightMouse"):
				mouseClick(e,"right")

@onready var camera_node: Camera3D = $Head/Camera3D
@onready var player_ray_cast_3d: RayCast3D = %PlayerRayCast3D
@onready var ray_length: float = player_ray_cast_3d.target_position.y

@export var collision_masks: int = 3

func mouseClick(e, mouseButton : String):
	#print_debug(collision_layer)
	var mouse_position = get_viewport().get_mouse_position()
	var ray_origin = camera_node.project_ray_origin(mouse_position)
	var ray_normal = camera_node.project_ray_normal(mouse_position)
	var ray_end = ray_normal * ray_length + ray_origin
	
	var world_3d = get_world_3d()
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = ray_origin
	ray_query.to = ray_end
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = true
	ray_query.collision_mask = collision_masks

	var result = world_3d.direct_space_state.intersect_ray(ray_query)

	if result:
		var hit_object = result.collider
		if mouseButton == "left":
			if e.is_action_pressed("leftMouse"):
				actionLeftCursor(hit_object)

var lastMousePosition: Vector2 = Vector2.ZERO
var showCursor : bool = false
func changeMouse():
	showCursor = !showCursor
	if showCursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.warp_mouse(lastMousePosition)
	else:
		lastMousePosition = get_viewport().get_mouse_position()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
