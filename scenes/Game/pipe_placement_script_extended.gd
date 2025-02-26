@tool
extends Node2D

signal is_queued_free

@onready var pipe_up: StaticBody2D = get_node("PipeUp")
@onready var pipe_down: StaticBody2D = get_node("PipeDown")
@onready var separation_marker: Marker2D = get_node("SeparationMarker")
@onready var scoreup_area: Area2D = get_node("ScoreUpArea")
@onready var scoreup_areacollision: CollisionShape2D = get_node("ScoreUpArea/ScoreUpAreaCollision")

@export_category("Pipe_Config")
@export var pipe_separation: float = 0.0
@export var pipe_position: float = 0.0
var pipe_offset: float

func _process(_delta: float) -> void:
	pipe_offset = 414.0
	separation_marker.position.y = pipe_up.position.y + pipe_separation
	scoreup_area.position.y = separation_marker.position.y
	scoreup_areacollision.shape.extents.y = pipe_separation
	pipe_up.position.y = pipe_position + pipe_offset - pipe_separation
	pipe_down.position.y = pipe_position + pipe_offset + pipe_separation

func _on_pipe_visible_screen_exited() -> void:
	self.queue_free()
	is_queued_free.emit()
