extends Microgame

@export var player: CharacterBody2D
@export var screen_shake: ColorRect
@export var attacked_timer: Timer
@export var wall_tile_map: TileMapLayer
@export var accessories_tile_map: TileMapLayer
@export var enemy: PackedScene
@export var enemy_spawner: Node2D
var lives_left: int = 3

func _ready() -> void:
	for i in range(6):
		summon_enemy()

func _process(delta: float) -> void:
	if game_playing and player.can_move == false:
		player.can_move = true
		for i in get_tree().get_nodes_in_group("enemies"):
			i.can_move = true
			i.connect("attacked", hurt_player)
	if game_playing:
		if get_tree().get_node_count_in_group("enemies") <= 0:
			player.can_move = false
			win_game.emit()

func hurt_player() -> void:
	if game_playing:
		lives_left -= 1
		print("%.0f lives left" % lives_left)
		shake_screen()
		if lives_left <= 0:
			player.can_move = false
			for i in get_tree().get_nodes_in_group("enemies"):
				i.can_move = false
			lose_game.emit()

func shake_screen() -> void:
	screen_shake.set_instance_shader_parameter("ShakeStrength", 1.0)
	attacked_timer.start()
	await attacked_timer.timeout
	screen_shake.set_instance_shader_parameter("ShakeStrength", 0.0)

func summon_enemy() -> void:
	var safe_pos: bool = false
	var x_pos: int
	var y_pos: int
	while not safe_pos:
		x_pos = randi_range(-13, 13)
		y_pos = randi_range(-12, 9)
		if wall_tile_map.get_cell_source_id(Vector2i(x_pos, y_pos)) == -1 and accessories_tile_map.get_cell_source_id(Vector2i(x_pos, y_pos)) == -1:
			safe_pos = true
	var en = enemy.instantiate()
	en._target = player
	en.global_position = wall_tile_map.to_global(wall_tile_map.map_to_local(Vector2i(x_pos, y_pos)))
	enemy_spawner.add_child(en)
