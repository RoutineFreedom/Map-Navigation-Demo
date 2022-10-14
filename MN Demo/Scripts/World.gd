extends Node2D

onready var line_2d: Line2D = $Line2D
onready var player_icon: KinematicBody2D = $Navigation2D/PlayerIcon

func _ready() -> void:
	line_2d.add_point(player_icon.position)

func _on_PlayerIcon_path_updated(path: PoolVector2Array) -> void:
	for point in path:
		line_2d.add_point(point)
