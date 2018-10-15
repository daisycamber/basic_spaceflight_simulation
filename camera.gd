# Written by Holton/Frankenstein/Le Saoût
# This script handles the camera. its pretty simple, just points the camera from 
# a position at the target and changes the position of the camera based on arrow keys
extends Camera

# Member variables
var collision_exception = []
export var angle_v_adjust = 0

# variables for controlling camera with arrow keys
var anglex = 0
var angley = 0
var distance = 30
var rotatespeed = 0.05

func _physics_process(dt):
	var target = get_parent().global_transform.origin
	var pos = global_transform.origin
	var up = Vector3(0, 1, 0)
	var delta = pos - target
	
	# Check ranges
	delta = delta.normalized()*distance
	pos = target+delta
	
	# get arrow keys and use em to adjust the camera and ship
	#var ship = get_parent().get_parent() # get ship
	# pan camera side to side while rotating ship
	if (Input.is_action_pressed("ui_right")):
		anglex = anglex-rotatespeed
	if (Input.is_action_pressed("ui_left")):
		anglex = anglex+rotatespeed
	# pan camera up and down without moving ship
	if (Input.is_action_pressed("ui_up")):
		angley = angley+rotatespeed
	if (Input.is_action_pressed("ui_down")):
		angley = angley-rotatespeed
	
	# update camera pos
	pos.x += cos(anglex) * distance
	pos.z += sin(anglex) * distance
	pos.y += cos(angley) * distance
	
	# point camera
	look_at_from_position(pos, target, up)
	
func _ready():
	# Find collision exceptions for ray
	var node = self
	while(node):
		if (node is RigidBody):
			collision_exception.append(node.get_rid())
			break
		else:
			node = node.get_parent()
	# This detaches the camera transform from the parent spatial node
	set_as_toplevel(true)
