extends KinematicBody2D

export (float) var max_speed := 500.0
export (float) var steering_damp := 6.0

onready var _agent: NavigationAgent2D = $NavigationAgent2D

var _velocity := Vector2.ZERO
var _path: PoolVector2Array

func _ready() -> void:
	_agent.set_target_location(global_position)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		_agent.set_target_location(get_global_mouse_position())
		print(_agent.get_final_location())
		
func _physics_process(delta: float) -> void:
	if _agent.is_target_reached():
		return
	else:
		var _direction := global_position.direction_to(_agent.get_next_location())
		# Modify velocity for steering behaviour
		var _desired_velocity := _direction * max_speed
		var _steering := (_desired_velocity - _velocity) * delta * steering_damp
		_velocity += _steering
		
		_velocity = move_and_slide(_velocity)

func _on_NavigationAgent2D_target_reached() -> void:
	_velocity = Vector2.ZERO

func _on_NavigationAgent2D_path_changed() -> void:
	_path = _agent.get_nav_path()
