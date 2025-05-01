extends Control

func _ready() -> void:
	visible = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = !visible
		
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && visible:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
