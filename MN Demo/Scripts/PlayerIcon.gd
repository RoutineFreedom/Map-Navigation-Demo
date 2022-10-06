extends KinematicBody2D

export (float) var max_speed := 500.0

onready var _agent: NavigationAgent2D = $NavigationAgent2D

var _velocity := Vector2.ZERO
var _destination := Vector2.ZERO 
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		_agent.set_target_location(get_global_mouse_position())
		_destination = event.global_position
		
func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		_destination = Vector2.ZERO
		return
	
	if _destination != Vector2.ZERO:
		var _direction := _destination.direction_to(_agent.get_next_location())
		print(_direction)
		# Modify velocity for steering behaviour
		var _desired_velocity := _direction * max_speed
		var _steering := (_desired_velocity - _velocity) * delta * 4.0
		_velocity += _steering
		
		_velocity = move_and_slide(_velocity)

