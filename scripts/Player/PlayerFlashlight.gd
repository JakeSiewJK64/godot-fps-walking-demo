extends SpotLight3D

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_flashlight"):
		visible = !visible
		return
