extends Node2D

@onready var animation_player: AnimationPlayer = $CanvasLayer2/AnimationPlayer

func _ready() -> void:
	animation_player.play_backwards("fade_out")

func _on_button_pressed() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")
