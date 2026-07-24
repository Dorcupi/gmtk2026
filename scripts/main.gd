extends Node2D
class_name MainGame

enum GAME_STATE {
	MAIN_SCENE,
	MINIGAME,
	MOVING_BACK
}

# -- CANVAS LAYER HEIRACRCHY --
# 999: Main Game Screen
#
# 2: Non-Canvas Layer Game UI Elements
# 1: Entire Game Canvas Layer

## Nodes
@export var time_left_label: Label
@export var microgame_button: MicrogameButton
@export var main_animation_player: AnimationPlayer
@export var microgame_spawner: Node2D

## Variables
@export var microgames: Array[PackedScene]
@onready var unplayed_microgames: Array[PackedScene] = microgames.duplicate()
@export var starting_time: float = 60.0
@export var start_add_amount: Array[float] = [5, 10]
var time_left: float = starting_time
var current_state: GAME_STATE = GAME_STATE.MAIN_SCENE
var current_microgame: Microgame
var add_amount: Array[float] = start_add_amount
var level: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	microgame_button.button.pressed.connect(start_microgame)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_left -= delta
	time_left_label.text = "%.0f" % time_left

func spawn_microgame() -> void:
	var microgame: Node
	if not unplayed_microgames.is_empty():
		var microgame_scene = unplayed_microgames.pick_random()
		unplayed_microgames.erase(microgame_scene)
		microgame = microgame_scene.instantiate()
	else:
		level_up()
		var microgame_scene = unplayed_microgames.pick_random()
		unplayed_microgames.erase(microgame_scene)
		microgame = microgame_scene.instantiate()
	microgame.win_game.connect(win_microgame)
	microgame.lose_game.connect(lose_microgame)
	current_microgame = microgame
	microgame_spawner.add_child(microgame)

func level_up() -> void:
	# insert code here to make game harder
	level += 1
	for i in add_amount:
		if not i <= 0.5:
			add_amount[add_amount.find(i)] = (i - 0.5)
	unplayed_microgames = microgames.duplicate()
	print("LEVEL UP")

func despawn_microgame() -> void:
	current_microgame.queue_free()
	current_microgame = null

func start_microgame() -> void:
	if current_state == GAME_STATE.MAIN_SCENE:
		current_state = GAME_STATE.MINIGAME
		spawn_microgame()
		main_animation_player.play("break_apart")
		await main_animation_player.animation_finished
		current_microgame.game_playing = true

func win_microgame() -> void:
	if current_state == GAME_STATE.MINIGAME:
		print("WIN GAME")
		time_left += snapped(randf_range(add_amount[0], add_amount[1]), 0.5)
		current_state = GAME_STATE.MOVING_BACK
		main_animation_player.play_backwards("break_apart")
		await main_animation_player.animation_finished
		despawn_microgame()
		current_state = GAME_STATE.MAIN_SCENE

func lose_microgame() -> void:
	if current_state == GAME_STATE.MINIGAME:
		print("LOSE GAME")
		current_state = GAME_STATE.MOVING_BACK
		main_animation_player.play_backwards("break_apart")
		await main_animation_player.animation_finished
		despawn_microgame()
		current_state = GAME_STATE.MAIN_SCENE
