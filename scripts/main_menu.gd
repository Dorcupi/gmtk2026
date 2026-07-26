extends Node2D

var main_menu: int = 1
var tween: Tween

@export var label: Label

func _process(delta: float) -> void:
	if main_menu == 1:
		if Input.is_anything_pressed():
			main_menu == 0
			tween = create_tween()
			tween.tween_property(label, "modulate", Color("ffffff00"), 0.5).from(Color("ffffff"))
			tween.tween_interval(0.2)
			tween.tween_callback(switch)

func switch() -> void:
	tween.kill()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
