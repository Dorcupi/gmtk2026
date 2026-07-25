extends Microgame

enum STAGE {
	PREPARED,
	WATCHING,
	REPLAYING,
	END
}

@export var off_brightness: Color
@export var on_brightness: Color

@export var lights: Array[TextureRect] = []
@export var buttons: Array[TextureButton] = []
@export var label: Label

var current_stage: STAGE = STAGE.PREPARED
var pattern: Array[int]

var current_spot_in_pattern: int = -1

var tween: Tween

func _ready() -> void:
	pattern = generate_pattern()
	for i in buttons:
		i.disabled = true
		i.connect("pressed", button_pressed.bind(buttons.find(i)))

func _process(delta: float) -> void:
	match current_stage:
		STAGE.PREPARED:
			if game_playing:
				current_stage = STAGE.WATCHING
		STAGE.WATCHING:
			if current_spot_in_pattern == -1:
				current_spot_in_pattern = 0
				play_pattern(current_spot_in_pattern)
		STAGE.REPLAYING:
			pass

func play_pattern(_position: int) -> void:
	if current_stage == STAGE.WATCHING:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(lights[pattern[_position]], "modulate", on_brightness, 0.2).from(lights[pattern[_position]].modulate).set_trans(Tween.TRANS_CUBIC)
		tween.tween_interval(0.2)
		tween.tween_property(lights[pattern[_position]], "modulate", off_brightness, 0.2).from(lights[pattern[_position]].modulate).set_trans(Tween.TRANS_CUBIC)
		tween.tween_callback(move_in_pattern)

func move_in_pattern() -> void:
	if current_spot_in_pattern == pattern.size() - 1:
		current_spot_in_pattern = 0
		current_stage = STAGE.REPLAYING
		for i in buttons:
			i.disabled = false
		label.text = "Replay the Pattern"
	else:
		current_spot_in_pattern += 1
		play_pattern(current_spot_in_pattern)

func generate_pattern() -> Array[int]:
	var length = randi_range(4, 8)
	var _pattern: Array[int] = []
	for i in range(1, length):
		var okay: bool = [true, false].pick_random()
		var current_part: int = randi_range(0, 3)
		while okay == false:
			if _pattern.size() >= 1 and current_part == _pattern[-1]:
				current_part = randi_range(0, 3)
			else:
				okay = true
		_pattern.append(current_part)
	return _pattern

func button_pressed(_position: int) -> void:
	if current_stage == STAGE.REPLAYING:
		var correct_button: int = pattern[current_spot_in_pattern]
		if correct_button == _position:
			if current_spot_in_pattern == pattern.size() - 1:
				current_stage = STAGE.END
				win_game.emit()
			else:
				current_spot_in_pattern += 1
		else:
			lose_game.emit()
