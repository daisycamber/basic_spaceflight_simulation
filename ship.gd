# Written by Holton/Frankenstein/Le Saoût
# This script handles the KinematicBody representing the spacecraft in this simulation.

extends KinematicBody

# Member variables
var g = 9810
var vel = Vector3()
const PLANET_SIZE = 127
const ATMOSPHERE_SIZE = PLANET_SIZE*.1
const ATMOSPHERIC_DRAG = 0.001
var thrust = 0.05
var rotationSpeed = 0.05

func _physics_process(delta):
	var dir = Vector3() # Where does the player intend to walk to
	var cam = get_node("target/camera") # camera
	var loc = get_translation() # location

	# atmospheric drag
	var dist = loc.distance_to(Vector3(0,0,0))
	if ( dist <= PLANET_SIZE + ATMOSPHERE_SIZE ):
		var depth = ATMOSPHERE_SIZE - (dist - PLANET_SIZE)
		var drag = depth * ATMOSPHERIC_DRAG
		if(vel.x >= 0):
			vel.x -= drag
		else:
			vel.x += drag
		if(vel.y >= 0):
			vel.y -= drag
		else:
			vel.y += drag
		if(vel.z >= 0):
			vel.z -= drag
		else:
			vel.z += drag

	# rotate craft on input, simulate hydrosene thrusters
	if (Input.is_action_pressed("w")):
		var rot = get_rotation()
		rot.z += rotationSpeed
		set_rotation(rot)
	if (Input.is_action_pressed("s")):
		var rot = get_rotation()
		rot.z -= rotationSpeed
		set_rotation(rot)
	if (Input.is_action_pressed("a")):
		#var rot = get_rotation()
		#rot.x += rotationSpeed
		rotate_x(rotationSpeed)
	if (Input.is_action_pressed("d")):
		rotate_x(-rotationSpeed)
	if (Input.is_action_pressed("q")):
		rotate_y(rotationSpeed)
	if (Input.is_action_pressed("e")):
		rotate_y(-rotationSpeed)

	# main thrust, get the ships vector (usin nodes) and apply thrust to the acceleration
	if (Input.is_action_pressed("space")):
		var vec = (get_node("front").get_global_transform().origin - get_node("back").get_global_transform().origin);
		vel.x += thrust * vec.x
		vel.y += thrust * vec.y
		vel.z += thrust * vec.z

	# handle gravity
	vel.x -= loc.x / g
	vel.y -= loc.y / g
	vel.z -= loc.z / g

	# move the launch vehicle
	vel = move_and_slide(vel,Vector3(0,0,0))