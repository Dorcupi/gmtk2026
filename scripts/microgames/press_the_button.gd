extends Microgame

@export var time_left_label: Label
@export var timer: Timer
@export var clicks_left_label: Label


var number_of_clicks_needed: float = randi_range(1, 12)
var clicks: float = number_of_clicks_needed

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if game_playing:
		if timer.is_stopped():
			timer.start(2)
		time_left_label.text = "%.2f" % timer.time_left
		clicks_left_label.text = "%.0f" % clicks

func _on_timer_timeout() -> void:
	if clicks == 0:
		win_game.emit()
	else:
		lose_game.emit()


func _on_button_pressed() -> void:
	clicks -= 1
		
