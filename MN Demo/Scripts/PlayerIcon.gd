extends KinematicBody2D

export (float) var max_speed := 500.0
export (float) var steering_damp := 6.0

onready var _agent: NavigationAgent2D = $NavigationAgent2D

var _velocity := Vector2.ZERO
var _destination := Vector2.ZERO 
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		_agent.set_target_location(get_global_mouse_position())
		#print(_agent.get_nav_path())
		_destination = event.global_position
		
func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		print("!!! FINISHED NAVIGATION !!!")
		_destination = Vector2.ZERO
		_velocity = Vector2.ZERO
		return
	
	if _destination != Vector2.ZERO:
		var _direction := _destination.direction_to(_agent.get_next_location()) * -1
		# Modify velocity for steering behaviour
		var _desired_velocity := _direction * max_speed
		var _steering := (_desired_velocity - _velocity) * delta * steering_damp
		#print("vel: ", _velocity, " steer: ", _steering)
		_velocity += _steering
		
		_velocity = move_and_slide(_velocity)

