extends RayCast3D

@onready var pauseMenu: ColorRect = $"../UI/PauseMenu"
@onready var playerInteractMessage: Control = $"../UI/InteractTooltip"
@onready var playerAudioPlayer: AudioStreamPlayer3D = $"../../AudioPlayer"

var hit: Node3D
var lastPickedTime: float = Time.get_unix_time_from_system()

const PICKUP_DELAY: float = .025

signal appendToInventory(item: ItemModel)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		if hit == null:
			return

		if pauseMenu != null && pauseMenu.visible:
			return

		var nodeType: String = hit.get_meta("node_type", "")

		if nodeType == null:
			return

		# handle door intraction
		if nodeType == "door":
			hit.interactDoor()
			return
		
		if nodeType == "item":
			# handle item pickup
			if Time.get_unix_time_from_system() - lastPickedTime < PICKUP_DELAY:
				return
			
			var newItem = ItemModel.new()
			newItem.item_type = hit.get("item_type")
			newItem.item_name = hit.get("item_name")
			newItem.item_image = hit.get("item_image")

			var itemPickupSound = hit.get("item_pickup_sound")

			if itemPickupSound:
				playerAudioPlayer.stream = itemPickupSound
				playerAudioPlayer.play()

			# append item to inventory
			appendToInventory.emit(newItem)
			lastPickedTime = Time.get_unix_time_from_system()
			hit.queue_free()

func _process(_delta: float) -> void:
	if is_colliding():
		# if pause menu open, ignore all raycast logic
		if pauseMenu != null && pauseMenu.visible:
			playerInteractMessage.hideTooltip()

		hit = get_collider()
		
		if hit == null:
			return
		
		var nodeType: String = hit.get_meta("node_type", "")
		if nodeType == "door":
			playerInteractMessage.showTooltip()

			if !hit.opened:
				playerInteractMessage.setTooltip("[center]Open door[/center]")
			else:
				playerInteractMessage.setTooltip("[center]Close door[/center]")
			return

		if nodeType == "item":
			var item_name: String = hit.get("item_name")
				
			# show pick up message
			if playerInteractMessage:
				if item_name:
					playerInteractMessage.showTooltip()
					playerInteractMessage.setTooltip("[center]Pick up " + item_name + "[/center]")
					return
				
				# hide the interact message if the item does not have 
				# a name
				playerInteractMessage.hideTooltip()
			return
	
	# reset raycast node
	hit = null
	# reset UI messages
	playerInteractMessage.hideTooltip()
