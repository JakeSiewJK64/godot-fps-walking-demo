extends Control

@onready var textureRect: TextureRect = $TextureRect

@export var texture: CompressedTexture2D

func _ready() -> void: 
	if texture == null:
		return

	textureRect.texture = texture
