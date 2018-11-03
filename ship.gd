# Written by Holton/Frankenstein/Le Saoût
# This script handles the KinematicBody representing the spacecraft in this simulation.
extends Spatial
# Member variables (what the fuck is this comment doing here)
var vel = Vector3()
var direction = Vector3()
var loc = Vector3()
var g = 981000
const PLANET_SIZE = 0#6371
const ATMOSPHERE_SIZE = PLANET_SIZE*.1
const ATMOSPHERIC_DRAG = 0.00003
const HYDRAZINE_SAFTEY_MARGIN = (PLANET_SIZE/2)*0.98
const BALOON_SAFTEY_MARGIN = PLANET_SIZE/2
const POLYMER_SAFTEY_MARGIN = (PLANET_SIZE/2) * 1.1
const NUCLEAR_SAFTEY_MARGIN = (PLANET_SIZE/2)*1.5

var hydrazineThrust = 0.01
var polymerThrust = 0.05
var nuclearThrust = 0.1
var rotationSpeed = 0.05

# print hud to screen (head up display)
func hud():
	var text = "Coordinates (xyz): " + String(loc) + "\n Direction: " + String(direction) + "\n Velocity: " + String(vel) + "\n"
	get_node("hud").set_text(text)

# apply vectored thrust to the craft (Vector3, float)
func apply_thrust(thrust):
	vel.x += thrust * direction.x
	vel.y += thrust * direction.y
	vel.z += thrust * direction.z
# process physics
func _physics_process(delta):
	var cam = get_node("target/camera") # camera
	loc = get_translation() # location
	#print(String(vel));
	# gettind direction from nodes, subtracting the vectors
	direction = (get_node("front").get_global_transform().origin - get_node("back").get_global_transform().origin);
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
	# rotate craft on input, simulate hydrazine thrusters
	if (Input.is_action_pressed("w")):
		rotate_z(rotationSpeed)
	if (Input.is_action_pressed("s")):
		rotate_z(-rotationSpeed)
	if (Input.is_action_pressed("a")):
		rotate_x(rotationSpeed)
	if (Input.is_action_pressed("d")):
		rotate_x(-rotationSpeed)
	# hydrazine main thrust, along vector without rotation
	if (Input.is_action_pressed("space") and Vector3(0,0,0).distance_to(loc) > HYDRAZINE_SAFTEY_MARGIN):
		apply_thrust(hydrazineThrust);
		# animate thrust by making particles visible
		get_node("hydrazine1/particles").visible = true;
		get_node("hydrazine2/particles").visible = true;
		get_node("hydrazine3/particles").visible = true;
		get_node("hydrazine4/particles").visible = true;
	else:
		get_node("hydrazine1/particles").visible = false;
		get_node("hydrazine2/particles").visible = false;
		get_node("hydrazine3/particles").visible = false;
		get_node("hydrazine4/particles").visible = false;
	# polymer thrust
	if (Input.is_action_pressed("p") and Vector3(0,0,0).distance_to(loc) > POLYMER_SAFTEY_MARGIN):
		apply_thrust(polymerThrust)
		# animate thrust by making particles visible
		get_node("polymerparticles").visible = true;
	else:
		get_node("polymerparticles").visible = false;
	# nuclear thrust
	if (Input.is_action_pressed("n") and Vector3(0,0,0).distance_to(loc) > NUCLEAR_SAFTEY_MARGIN):
		apply_thrust(nuclearThrust)
		# animate thrust by making particles visible
		get_node("nuclearparticles").visible = true;
	else:
		get_node("nuclearparticles").visible = false;
	# handle gravity (innacuratley lol)
	
	#vel.x -= loc.x / g
	#vel.y -= loc.y / g
	#vel.z -= loc.z / g
	#print(vel)
	var m = loc + vel
	if(Vector3(0,0,0).distance_to(loc+vel) < (PLANET_SIZE + 1)):
		vel = Vector3(0,0,0)
	#else if(not Vector3(0,0,0).distance_to(loc+vel) > (PLANET_SIZE/2+3)):
	global_translate(vel)
	# move the crafts
	
	# draw hud
	hud()