extends CharacterBody3D

@export var item_name: String
@export var item_type: String
@export var item_image: CompressedTexture2D
@export var item_pickup_sound: AudioStreamMP3
 
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# gravity
	velocity.y -= gravity * delta
	move_and_slide()
