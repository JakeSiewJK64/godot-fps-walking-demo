extends CharacterBody3D

@onready var navAgent: NavigationAgent3D = $NavigationAgent3D
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var speed: float = 4

var nextLocation: Vector3
var currentLocation: Vector3
var newVelocity: Vector3
	
func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= gravity * delta

	# get point B location
	nextLocation = navAgent.get_next_path_position()

	# get current location
	currentLocation = global_transform.origin

	# get new direction
	newVelocity = (nextLocation - currentLocation).normalized() * speed

	velocity = velocity.move_toward(newVelocity, .25)
	move_and_slide()

func targetPosition(target: Vector3):
	navAgent.target_position = target
