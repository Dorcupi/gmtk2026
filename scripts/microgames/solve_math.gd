extends Microgame

@export var question_label: Label

@export var option_buttons: Array[TextureButton]
var question: Array[int]
var correct_button: TextureButton

func _ready() -> void:
	generate_buttons(generate_question())

func generate_question() -> Array[int]:
	var first_number: int = randi_range(1, 9)
	var second_number: int = randi_range(1, 9)
	var operation: int = randi_range(1, 2)
	var answer: int
	if operation == 1:
		answer = first_number + second_number
	else:
		answer = first_number - second_number
	return [first_number, second_number, operation, answer]

func generate_buttons(question: Array) -> void:
	var good_button: int = randi_range(0, option_buttons.size() - 1)
	correct_button = option_buttons[good_button]
	for i in option_buttons:
		if i == correct_button:
			i.get_node("Label").text = "%.0f" % question[3]
			i.pressed.connect(pick_right_button)
		else:
			var modifier: int = 0
			while modifier == 0:
				modifier = randi_range(-5, 5)
			i.get_node("Label").text = "%.0f" % (question[3] + modifier)
			i.pressed.connect(pick_wrong_button)
	if question[2] == 1:
		question_label.text = "%.0f + %.0f" % [question[0], question[1]]
	else:
		question_label.text = "%.0f - %.0f" % [question[0], question[1]]

func pick_right_button() -> void:
	if game_playing:
		win_game.emit()

func pick_wrong_button() -> void:
	if game_playing:
		lose_game.emit()
