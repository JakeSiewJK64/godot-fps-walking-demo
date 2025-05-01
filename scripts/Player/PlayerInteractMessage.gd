extends Control

@export var richTextLabel: RichTextLabel
@export var textureRect: TextureRect

# sets tooltip message
func setTooltip(message: String) -> void:
	richTextLabel.text = message
	return

func hideTooltip() -> void:
	richTextLabel.visible = false
	textureRect.visible = false

# exposes the tooltip
func showTooltip() -> void:
	richTextLabel.visible = true
	textureRect.visible = true

func _ready():
	hideTooltip()
