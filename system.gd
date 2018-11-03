
# this class builds a solar system to specs
extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# sun is 1.391 million km in w
# variables
var universalScale = 0.001
var sunSize = 1391016 * universalScale
var planetSize = 12742 * universalScale
var minSeperation=(12742+1391016) * universalScale


# member bodies
var starMat
var sun
var planet

var planets = Array()


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	var sun = get_node("star").duplicate()
	sun.global_scale(Vector3(sunSize,sunSize,sunSize))
	sun.visible = true
	add_child(sun)
	planets.append(sun)
	
	var planet = get_node("planet").duplicate()
	planet.global_scale(Vector3(planetSize,planetSize,planetSize))
	planet.visible = true
	add_child(planet)
	planets.append(planet)
	
	
	#sun = SphereMesh.new()
	#sun.radius = 10
	#sun.height = 10
	#sun.translate(sun.get_transform().scaled(Vector3(10,10,10)));
	#starMat = SpatialMaterial.new();
	#starMat.scaled(Vector3(10,10,10))
	#starMat.emission = Color(100,1,1);
	#starMat.albedo_color = Color(1,1,1);
	#starMat.energy = 1;
	#starMat.emission_enabled = true;
	#starMat.emission_energy = 1;
	#starMat.emission_operator = 0
	#sun.material = starMat
	#add_child(sun);
	#planet = duplicate(get_node("planet"))
	#planet.scale(Vector3(10,10,10))
	
	#planet.global_translate(10,0,0)
	
	pass
	
var planetOrbit = 0;
var x = 0
var z = 0
func _physics_process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	x = cos(planetOrbit) * minSeperation;
	z = sin(planetOrbit) * minSeperation;
	if(planet):
		planet.global_translate(Vector3(x,0,z));
	planetOrbit+=0.01
	pass
