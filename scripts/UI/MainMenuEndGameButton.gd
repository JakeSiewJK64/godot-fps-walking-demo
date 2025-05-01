extends Button

func _toggled(_toggled_on: bool) -> void:
	get_tree().quit()
