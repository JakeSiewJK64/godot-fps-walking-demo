extends ColorRect

@onready var startGame: Button = $Control/StartGameButton
@onready var endGame: Button = $Control/EndGameButton

var focusIndex: int = 0

const BUTTON_COUNT = 2

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE) || Input.is_key_pressed(KEY_ENTER):
		match focusIndex:
			0:
				startGame.button_pressed = true
				return
			1:
				endGame.button_pressed = true
				return
		return
	
	if Input.is_key_pressed(KEY_UP) && focusIndex > 0:
		focusIndex -= 1
	
	if Input.is_key_pressed(KEY_DOWN) && focusIndex < BUTTON_COUNT - 1:
		focusIndex += 1
