extends Node3D

@export var animationPlayer: AnimationPlayer
@export var audioPlayer: AudioStreamPlayer3D

@onready var DOOR_OPEN_SOUND = preload("res://assets/audio/sfx/door_open.mp3")
@onready var DOOR_CLOSE_SOUND = preload("res://assets/audio/sfx/door_close.mp3")

var opened: bool = false

func interactDoor() -> void:
	if animationPlayer.is_playing():
		return

	if !opened:
		audioPlayer.pitch_scale = 1
		audioPlayer.stream = DOOR_OPEN_SOUND
		audioPlayer.play()
		animationPlayer.play("open")
		opened = true
		return
		
	animationPlayer.play("close")
	opened = false
	audioPlayer.pitch_scale = .5
	audioPlayer.stream = DOOR_CLOSE_SOUND
	audioPlayer.play()
