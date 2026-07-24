extends CharacterBody2D

enum STATE {
	CHASING,
	ATTACKING
}

@export var speed: float = 150
@export var knockback_distance: float = 250
@export var nav_agent: NavigationAgent2D
@export var nav_timer: Timer
@export var _target: Node2D

var can_move: bool = false
var current_state: STATE = STATE.CHASING

signal attacked

func _ready() -> void:
	nav_timer.timeout.connect(_update_target_position)
	nav_timer.start()
	
func _update_target_position() -> void:
	if _target:
		nav_agent.target_position = _target.global_position
		nav_timer.start()
		
func _physics_process(delta: float) -> void:
	match current_state:
		STATE.CHASING:
			if nav_agent.is_navigation_finished() or not can_move:
				return
			
			var next_pos = nav_agent.get_next_path_position()
			var direction = (next_pos - global_position).normalized()
			velocity = direction * speed
			look_at(_target.global_position)
			move_and_slide()
		STATE.ATTACKING:
			if nav_agent.is_navigation_finished() or not can_move:
				return
			
			var next_pos = nav_agent.get_next_path_position()
			var direction = (next_pos - global_position).normalized()
			velocity = -direction * (speed * 2)
			look_at(_target.global_position)
			move_and_slide()
			
			if global_position.distance_to(_target.global_position) >= knockback_distance:
				current_state = STATE.CHASING


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == _target:
		if current_state == STATE.CHASING:
			current_state = STATE.ATTACKING
			attacked.emit()
