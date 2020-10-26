extends KinematicBody

onready var head = $Head

var movementSpeed = 6
var acceleration = 3
var decceleration = 5

var jumpForce = 0.5

#Earths Gravity is -9.8 m/s
var gravity = -19.6

var player
var cam
var velocity = Vector3()

var mouseSensitivity = 0.05
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player = get_node("../Player").get_global_transform()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouseSensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouseSensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	
func _physics_process(delta):
	var dir = Vector3()
	
	if(Input.is_action_pressed("forward")):
		dir += -transform.basis[2]
	if(Input.is_action_pressed("backward")):
		dir += transform.basis[2]
	if(Input.is_action_pressed("left")):
		dir += -transform.basis[0]
	if(Input.is_action_pressed("right")):
		dir += transform.basis[0]
		
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * gravity
	
	var horizontalVelocity = velocity
	horizontalVelocity.y = 0
	
	var new_pos = dir * movementSpeed
	var accel = decceleration
	
	if(dir.dot(horizontalVelocity) > 0):
		accel = acceleration
	
	horizontalVelocity = horizontalVelocity.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = horizontalVelocity.x
	velocity.z = horizontalVelocity.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0), true)
	
	if(is_on_floor() and Input.is_action_pressed("jump")):
		velocity.y += jumpForce * -gravity
	
