extends KinematicBody2D

signal path_updated

export (float) var max_speed := 500.0
export (float) var steering_damp := 6.0
export (int) var rect_size := 250

onready var _agent: NavigationAgent2D = $NavigationAgent2D

var _velocity := Vector2.ZERO
var _target_location := Vector2.ZERO
var _confirm_location := Vector2.ZERO
var _target_area: Rect2
var _path: PoolVector2Array
var _click_count := 0
var _can_move := false

func _ready() -> void:
	_agent.set_target_location(global_position)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		# Player has clicked once, set this location as target
		if _click_count == 0:
			_target_location = get_global_mouse_position()
			_agent.set_target_location(_target_location)
			# Create rectangle with target location as the middle point
			var _top_left = Vector2(_target_location.x - rect_size / 2, _target_location.y - rect_size / 2)
			_target_area = Rect2(_top_left, Vector2(rect_size, rect_size))
			print("loc: ", _target_location, "area: ", _target_area)
		# Player has clicked twice, set this location as potential confirmation
		else:
			_confirm_location = get_global_mouse_position()
			print("conf:", _confirm_location)
			_can_move = _target_area.has_point(_confirm_location)
			
		_click_count += 1
		
func _physics_process(delta: float) -> void:
	if _agent.is_target_reached():
		return
	elif _click_count > 1 and _can_move:
		var _direction := global_position.direction_to(_agent.get_next_location())
		# Modify velocity for steering behaviour
		var _desired_velocity := _direction * max_speed
		var _steering := (_desired_velocity - _velocity) * delta * steering_damp
		_velocity += _steering
		
		_velocity = move_and_slide(_velocity)

func _on_NavigationAgent2D_target_reached() -> void:
	_velocity = Vector2.ZERO
	_click_count = 0
	_can_move = false

func _on_NavigationAgent2D_path_changed() -> void:
	_path = _agent.get_nav_path()
	emit_signal("path_updated", _path)
