extends Node3D

# enable for horror games
@export var DIM_LIGHT: bool = true

@onready var target = $"../Player"
@onready var worldEnvironment: WorldEnvironment = $WorldEnvironment
@onready var sun: DirectionalLight3D = $WorldEnvironment/Sun

func _process(_delta: float) -> void:
	# calls EnemyGroup
	# calls enemy class target_position function
	# returns the global_transform.origin as argument
	get_tree().call_group("EnemyGroup", "targetPosition", target.global_transform.origin)

func _ready() -> void:
	if worldEnvironment == null:
		return

	if DIM_LIGHT:
		worldEnvironment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_DISABLED
		worldEnvironment.environment.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
		sun.visible = false
		return
	
	worldEnvironment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	worldEnvironment.environment.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
	sun.visible = true
	return
