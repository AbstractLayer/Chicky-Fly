extends Node2D

@onready var pipe_placement = load("res://scenes/Game/pipe_placement.tscn")
@onready var difficult_timer: Timer = %DifficultTimer
@onready var pinto: pinto_character = %Pinto
@onready var gain_points_sound: AudioStreamPlayer = %GainPointsSound

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var loop_position_x: int = 420
var loop_increase_position: int = 420
var difficult_decrease_separation: int = 70

var score_value: int = 0

var difficultimer_start: bool = false

func _ready() -> void:
	first_pipe_creation()
	
func body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not difficultimer_start:
			difficult_timer.start()
			difficultimer_start = true
		gain_points_sound.pitch_scale = rng.randf_range(0.8,1.2)
		gain_points_sound.play()
		score_value += 1

func is_pipe_queued_free() -> void:
	var pipe_instance = pipe_placement.instantiate()
	pipe_instance.add_to_group("Pipes")
	pipe_instance.global_position.x = loop_position_x
	pipe_instance.pipe_separation = difficult_decrease_separation
	pipe_instance.pipe_position = rng.randi_range(-280,0)
	add_child(pipe_instance)
	pipe_instance.scoreup_area.connect("body_entered", body_entered)
	pipe_instance.connect("is_queued_free", is_pipe_queued_free)
	loop_position_x += loop_increase_position

func _on_difficult_timer_timeout() -> void:
	if difficult_decrease_separation > 45:
		difficult_decrease_separation -= 5
	else:
		difficult_decrease_separation = 45

func _on_flappy_bird_try_again() -> void:
	score_value = 0
	var pipes_try_again_queuefree = get_tree().get_nodes_in_group("Pipes")
	for pipes in pipes_try_again_queuefree:
		pipes.queue_free()
	pinto.global_position = Vector2(36,256)
	loop_position_x = 420
	difficult_decrease_separation = 70
	difficultimer_start = false
	first_pipe_creation()

func first_pipe_creation() -> void:
	var pipe_instance = pipe_placement.instantiate()
	pipe_instance.add_to_group("Pipes")
	pipe_instance.pipe_separation = 70
	pipe_instance.pipe_position = rng.randi_range(-280,0)
	add_child(pipe_instance)
	pipe_instance.scoreup_area.connect("body_entered", body_entered)
	pipe_instance.connect("is_queued_free", is_pipe_queued_free)
