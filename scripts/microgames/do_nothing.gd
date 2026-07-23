extends Microgame

var time_left: float = randi_range(3, 5)
var game_on: bool = true

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if game_playing:
		if Input.is_anything_pressed():
			game_on = false
			lose_game.emit()
		time_left -= delta
		if time_left <= 0 and game_on:
			win_game.emit()
