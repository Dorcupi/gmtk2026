extends CharacterBody2D

@export var bullet: PackedScene
@export var bullet_spawn_position: Marker2D
@export var speed = 300.0
var can_move: bool = false

func _physics_process(delta: float) -> void:

	look_at(get_global_mouse_position())
	
	if can_move:
		var x_axis_direction := Input.get_axis("move_left", "move_right")
		var y_axis_direction := Input.get_axis("move_up", "move_down")
		if x_axis_direction:
			velocity.x = x_axis_direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		if y_axis_direction:
			velocity.y = y_axis_direction * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
			
		if Input.is_action_just_pressed("attack"):
			shoot()

	move_and_slide()

func shoot() -> void:
	var bul: Area2D = bullet.instantiate()
	bul.transform = bullet_spawn_position.global_transform
	owner.add_child(bul)
