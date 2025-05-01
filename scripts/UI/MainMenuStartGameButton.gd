extends Button

func _toggled(_toggled_on: bool) -> void:
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")
