class_name ItemModel

@export var item_type: String
@export var item_name: String
@export var item_image: CompressedTexture2D

func _to_string() -> String:
	return "Item name: " + item_name + ", type: " + item_type + ", image: " + item_image.to_string()
