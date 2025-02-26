extends Node2D
class_name FlappyBirdGame

signal try_again

@onready var up: StaticBody2D = %Up
@onready var down: StaticBody2D = %Down
@onready var pinto: CharacterBody2D = %Pinto
@onready var pipes: Node2D = %Pipes
@onready var menu_panel: Panel = %MenuPanel
@onready var game_over_panel: Panel = %GameOverPanel
@onready var label_score: Label = %LabelScore
@onready var score: Label = %Score
@onready var label_high_score: Label = %LabelHighScore
@onready var highscore: Label = %Highscore
@onready var score_over: Label = %ScoreOver
@onready var highscore_over: Label = %HighscoreOver
@onready var space_sprite: Sprite2D = %SpaceSprite
@onready var main_animation_player: AnimationPlayer = %MainAnimationPlayer
@onready var game_over_sound: AudioStreamPlayer = %GameOverSound
@onready var menu_sound: AudioStreamPlayer = %MenuSound

var highscore_value: int = 0

func _ready() -> void:
	menu_panel.show()
	pinto.set_physics_process(false)

func _process(_delta: float) -> void:
	up.position.x = pinto.global_position.x
	down.position.x = pinto.global_position.x
	score.text = str("%d" % [pipes.score_value])
	highscore.text = str("%d" % [highscore_value])
	if pipes.score_value > highscore_value:
		highscore_value = pipes.score_value
	
func _on_play_button_pressed() -> void:
	menu_sound.play()
	space_sprite.show()
	main_animation_player.play("Space_Animation")
	menu_panel.hide()
	label_score.show()
	score.show()
	label_high_score.show()
	highscore.show()
	pinto.set_physics_process(true)
	await get_tree().create_timer(1).timeout
	Global.emit_one_time = false
	await get_tree().create_timer(2.5).timeout
	space_sprite.hide()
	main_animation_player.stop()

func _on_pinto_game_over() -> void:
	game_over_sound.play()
	score_over.text = str("Score: %d" % [pipes.score_value])
	highscore_over.text = str("Highscore: %d" % [highscore_value])
	game_over_panel.show()
	label_score.hide()
	score.hide()
	pinto.set_physics_process(false)
	pipes.difficult_timer.stop()

func _on_try_again_button_pressed() -> void:
	menu_sound.play()
	game_over_panel.hide()
	menu_panel.show()
	try_again.emit()
