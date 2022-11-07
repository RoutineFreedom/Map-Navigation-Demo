extends KinematicBody2D

signal path_updated
signal target_reached
signal target_set
signal clicked

export (float) var max_speed := 500.0
export (float) var steering_damp := 6.0
export (int) var rect_size := 250

onready var _agent: NavigationAgent2D = $NavigationAgent2D

var _velocity := Vector2.ZERO
var _target_location := Vector2.ZERO
var _target_area: Rect2
var _path: PoolVector2Array
var _click_count := 0

func _ready() -> void:
	_agent.connect("velocity_computed", self, "move")
	_agent.set_target_location(global_position)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		var _debug_text := "Path Chosen"
		# Player has clicked once, set this location as target
		if _click_count == 0:
			set_target()
		# Player has clicked twice, set this location as potential confirmation
		else:
			var _confirm_location = get_global_mouse_position()
			 
			# Only update to second click if it is withing target area
			if _target_area.has_point(_confirm_location):
				_debug_text = "Path Confirmed"
				_click_count += 1
			# Otherwise just change target
			else:
				_debug_text = "Path Re-Chosen"
				_click_count = 0
				set_target()
				
		emit_signal("clicked", _debug_text)
		
func _physics_process(delta: float) -> void:
	if _agent.is_target_reached():
		return
	elif _click_count > 1:
		var _direction := global_position.direction_to(_agent.get_next_location())
		# Modify velocity for steering behaviour
		var _desired_velocity := _direction * max_speed
		var _steering := (_desired_velocity - _velocity) * delta * steering_damp
		_velocity += _steering
		
		_agent.set_velocity(_velocity)
		
func move(velocity: Vector2) -> void:
	_velocity = move_and_slide(velocity)
		
func set_target() -> void:
	_click_count += 1
	_target_location = get_global_mouse_position()
	_agent.set_target_location(_target_location)
	_agent.get_next_location()
	# Create rectangle with target location as the middle point
	var _top_left = Vector2(_target_location.x - rect_size / 2, _target_location.y - rect_size / 2)
	_target_area = Rect2(_top_left, Vector2(rect_size, rect_size))
	emit_signal("target_set", _target_location, position.angle_to_point(get_global_mouse_position()))

func _on_NavigationAgent2D_target_reached() -> void:
	_velocity = Vector2.ZERO
	_click_count = 0
	emit_signal("target_reached")

func _on_NavigationAgent2D_path_changed() -> void:
	_path = _agent.get_nav_path()
	emit_signal("path_updated", _path)
