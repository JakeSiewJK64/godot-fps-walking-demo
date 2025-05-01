extends CharacterBody3D

const JUMP_HEIGHT = 4
const MOVEMENT_SPEED_GROUND = 0.2
const MOVEMENT_SPEED_AIR = 0.11
const MOVEMENT_FRICTION_GROUND = 0.9
const MOVEMENT_FRICTION_AIR = 0.98
const HEADBOB_FREQUENCY: float = 2.
const HEADBOB_AMPLITUDE: float = .05

@export var mouse_sensitivity: float = 1.

var inventory: Array[ItemModel] = [];
var _mouse_motion: Vector2 = Vector2()
var headbob_time: float = .0
var walkSound: Resource = preload("res://assets/audio/sfx/walk1.mp3")

@onready var itemContainer: PackedScene = preload("res://scenes/UI/ItemContainer.tscn")
@onready var audioPlayer: AudioStreamPlayer3D = $AudioPlayer
@onready var stairTrigger: Area3D = $StairsTrigger
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var head: Node3D = $Head
@onready var raycast: RayCast3D = $Head/RayCast3D
@onready var inventoryGrid: GridContainer = $"Head/UI/PauseMenu/Inventory/GridContainer"

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	raycast.connect("appendToInventory", appendToInventory)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_mouse_motion += event.relative * mouse_sensitivity

func appendToInventory(item: ItemModel) -> void:
	inventory.append(item)

	# render the item in the inventory
	var item_ui: Node = itemContainer.instantiate()
	item_ui.set("texture", item.item_image)
	inventoryGrid.add_child(item_ui)

func _process(_delta: float) -> void:
	# mouse movement
	_mouse_motion.y = clampf(_mouse_motion.y, -1560, 1560)
	transform.basis = Basis.from_euler(Vector3(0, _mouse_motion.x * -.001, 0))
	head.transform.basis = Basis.from_euler(Vector3(_mouse_motion.y * -.001, 0, 0))

func _physics_process(delta: float) -> void:
	# keyboard movement
	var movement_vec2: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var movement: Vector3 = transform.basis * (Vector3(movement_vec2.x, 0, movement_vec2.y)).normalized()

	if is_on_floor():
		movement *= MOVEMENT_SPEED_GROUND		
	else:
		movement *= MOVEMENT_SPEED_AIR

	if movement:
		# walk up stairs
		if stairTrigger.stairs > 0:
			velocity.y = 1.8
		if audioPlayer && !audioPlayer.playing:
			audioPlayer.stream = walkSound
			audioPlayer.play()
	
	# headbob
	headbob_time += delta * velocity.length() * float(is_on_floor())
	head.transform.origin = process_headbob(headbob_time)

	# gravity
	velocity.y -= gravity * delta
	velocity += Vector3(movement.x, 0, movement.z)

	# apply friction, otherwise you will slide
	if is_on_floor():
		velocity.x *= MOVEMENT_FRICTION_GROUND
		velocity.z *= MOVEMENT_FRICTION_GROUND

	if !is_on_floor():
		velocity.x *= MOVEMENT_FRICTION_AIR
		velocity.z *= MOVEMENT_FRICTION_AIR
	
	move_and_slide()

	if is_on_floor() && Input.is_action_pressed("jump"):
		velocity.y = JUMP_HEIGHT

func process_headbob(time: float):
	var headbob_position = Vector3.ZERO
	headbob_position.y = sin(time * HEADBOB_FREQUENCY) * HEADBOB_AMPLITUDE
	headbob_position.x = cos(time * HEADBOB_FREQUENCY / 2) * HEADBOB_AMPLITUDE

	return headbob_position
