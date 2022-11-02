extends Node2D

onready var line_2d: Line2D = $Line2D
onready var player_icon: KinematicBody2D = $Navigation2D/PlayerIcon
onready var debug_label: Label = $DebugLabel

func _ready() -> void:
	line_2d.add_point(player_icon.position)

func _on_PlayerIcon_path_updated(path: PoolVector2Array) -> void:
	# Reset points if there's already a line drawn and the path is updated
	if line_2d.get_point_count() > 1:
		line_2d.clear_points()
		line_2d.add_point(player_icon.position)
	# Make a line to the path
	for point in path:
		line_2d.add_point(point)

func _on_PlayerIcon_target_reached() -> void:
	debug_label.text = "Path Reached"
	line_2d.clear_points()

func _on_PlayerIcon_clicked(debug_text: String) -> void:
	debug_label.text = debug_text
